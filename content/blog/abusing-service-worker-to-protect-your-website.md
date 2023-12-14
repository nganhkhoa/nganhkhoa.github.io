---
title: "Abusing Service Worker for web protection"
subtitle: ""
summary: ""
tags: []
categories: []
published: "2023-12-14"
featured: false
draft: false
---

# Intro

Recently, I have been testing on service worker. And I thought of an idea that we can use to cover the traces of web protection. This is a draft idea and have not been PoC, but in theory, it should work.

# What is a Worker

I have been working on the web for so many years, yet Web Worker is something that I do not work on. Mainly because the Javascript is so powerful and most of the web applications use Javascript only. But the browser has a feature for us to run Javascript on another thread.

We all know that Javascript is single-threaded. But the browser runs in multi-thread (obviously), and it can control multiple contexts of Javascript. This is why the browser can run multiple tabs at a time, using multi-threading architecture. So someone also thought that for each webpage, we can have background threads. And it is defined as Web Workers.

There are multiple types of "worker". A dedicated worker is a worker that can be accessed by the script that calls the worker. A shared worker can be accssed by any scripts.

The communication between worker and the main thread is quite complicated. The simplest communication method is through the use of `postMessage` function and `onmessage` event. Yes they are event-based APIs, Javascript is event-based fyi.

## What about Service Worker

Service Worker is a special kind of worker. This is a worker that can monitor the whole webpage after it has been *installed*. Service Worker only needs to be created one time and it will be installed in the context of the webpage.

The most common use of Service Worker is caching of resources. Usually resources fetching logic is embeded in the application. Each fetch calls connect to the server to download the resource but it can be cached and the Service Worker is mostly use for this usecase.

It has this usecase because the Service Worker can intercept **fetch** invocations, and has a separate storage.

## Service Worker tutorial

To continue, we should know how to setup a Service Worker. I should stress that worker cannot be run in a **file** manner, which means we must host those file through a web server. So let's build a simple web server with Flask, because I do not like `node_modules` piling up the storage for simple application.

```py
from flask import Flask, make_response

app = Flask("dummy test server")
index = """
<head>
    <!-- starting script -->
    <script type="text/javascript" src="/index.js"></script>
</head>

<body>
</body>

"""

@app.route("/")
def main():
    return index

@app.route("/index.js")
def bshield():
    bshieldjs = open("index.js").read()
    return bshieldjs

# service worker to hook request
# this uses worker.wasm for hooking logic
# mainly to hook fetch() requests or resources fetch on html load
@app.route("/sw.js")
def service_worker():
    sw = open("sw.js").read()
    resp = make_response(sw, 200)
    resp.headers['Service-Worker-Allowed'] = '/'
    resp.content_type = "text/javascript"
    return resp

if __name__ == '__main__':
    app.run(host="localhost", port=3000, debug=True)
```

Our server exposes 3 endpoints, the `/` hosting the `index.html` file, `/index.js` hosting the main script `index.js` and `/sw.js` hosting the service worker code.

> The basic way to create a worker is through files. Blobs can also be used.

The service worker must be specified to be of type `text/javascript` and the `Service-Worker-Allowed` field in the header set to `/` to denote the scope. The scope basically tells under what sub-page the service worker can be run, `/` means it can be run on any page of our website.

To "start" or "create" a service worker, we put the following code in `index.js`.

```javascript
navigator.serviceWorker.register(
  '/sw.js',
  { scope: '/' }
}).then(reg => {
  if (reg.installing) {
    const sw = reg.installing || reg.waiting;
    sw.onstatechange = function() {
      if (sw.state === 'installed') {
        setTimeout(function() {
          window.location.reload();
        }, 0);
      }
    };
  }
})
.catch(error => console.log(error))
```

It should be straight forward to understand the code. We "register" a service worker where the logic is at `/sw.js`, and the scope is `/`. Then we register a state change event callback to refresh the page if the service worker is **installed**. The refresh is required because the first time the service worker is "created", it cannot capture the current page.

To intercept the fetch invocations, we put the following code in the `sw.js`.

```javascript
self.onfetch = (event) => {
    if (/* no-intercep */) {
        return;
    }

    // return another response object
    event.respondWith(fetch(""));
}
```

Now the service worker can intercept fetch invocations and we can monitor or replace the response. The response can be replaced with another fetch (redirect), or static content.

So it can be used for intercepting requests but not only requests. It can also intercept resources downloaded at the HTML parsing stage. This means that all resources in the HTML can be monitored by the service worker, including `<script>`, `<img>`, `<link>` tags.

> I still have not tested the `<link>` tag

This feature will be used later for web protection.

# Website protection

Current web protection relies on many strategies. Most commonly, methods such as obfuscating the sourcecode and protection code insertion are used. Obfuscation is not unrelated to our context, so I will explain how protection code insertion can protect the website.

Obviously, protection should prevent tampering of sourcecode as well as debugging. Because the Javascript is a dynamic environment it is easy to tamper with the runtime. The goal for protection should be to limit the possibility for such tampering to happen. And a straight forward method for this is through insertion of checkers, preventors, traps and let it load together when the website is rendering. The code is periodically run to check for abnormal behaviour also.

I will not go into how the prevention is performed, but I can at least say that these code are often included as a separated script from the "normal operation" code. A demonstration will be a HTML that loads like below:

```html
<head>
    <!-- protection script -->
    <script type="text/javascript" src="/protect.js"></script>

    <!-- starting script -->
    <script type="text/javascript" src="/index.js"></script>
</head>

<body>
</body>
```

In the code above, `index.js` is the application code, and the `protect.js` is the protection script.


# Abusing Service Worker for Website protection

## Simple case

Let's explore how we can use Service Worker and incorperate them to the protection of websites. I started with having the `protect.js` loads a Service Worker. The logic for the `protect.js` should **only loads the Service Worker** instead of performing protection logic.

Let's put all protection logic into a different script called `protect-logic.js`. We now define the Service Worker as below:

```javascript
self.onfetch = (event) => {
    if (event.request.url === "https://root/protect.js") {
        event.respondWith(fetch("/protect-logic.js"));
        return;
    }
}
```

What this does is, when the webpage with Service Worker installed, by the HTML resource, the `protect.js` is requested, but intercepted by the Service Worker to return a different file, `protect-logic.js`. In the `protect-logic.js`, the code to load the Service Worker is also there for Service Worker management. But the rest of the code can be the protection code.

## Advanced case

`event.respondWith` is compatible with any kind of data as long as it represents the object Response. Instead of redirecting to another request invocation, we can actually build a custom response that returns a file content. It becomes:

```javascript
const res = Respond(body, {status, headers});
event.respondWith(res);
return;
```

Let body be an array of characters (`Blob`, `ArrayBuffer`) and we can put the script in memory. With the script encrypted, our Service Worker decrypts the content when the resource is required and return.

Using the same logic with the application script, e.g., `index.js`, and its resources (css and images). The Service Worker is responsible for all resource resolvements.

By the logic of redirection, we can actually use fake names to load files. Instead of specifying `index.js` and `protect.js`, we can put random names like `a.js`, `b.js` with their corresponding mapping to files and build the logic for Service Worker to resolve the correct file.

## Extreme case

The Service Worker code is currently written in Javascript and easy to understand the logic. I would not disclose how, but the Service Worker logic can be run through the Web Assembly. And Web Assembly is hard to read so it adds a layer of protection.

Combined, the Service Worker can be used to build a custom file resolver for all resources required. The user cannot disable the Service Worker (through Developer's Application -> Bypass for network) because it is responsible for files requests.

I should note that there was a [research](https://repositorio-aberto.up.pt/bitstream/10216/136432/2/499388.pdf) using Service Worker for intercepting requests and filter them out to prevent third-party libraries making "malicious requests" to "known server" (supply chain attack).
