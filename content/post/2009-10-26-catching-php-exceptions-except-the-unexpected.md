---
title: 'Catching PHP Exceptions: Except the unexpected'
author: Tibo Beijen
layout: post
date: 2009-10-26T11:57:20+00:00
url: /blog/2009/10/26/catching-php-exceptions-except-the-unexpected/
postuserpic:
  - /pa_basketball_80.jpg
categories:
  - articles
tags:
  - design
  - design patterns
  - exception
  - oop
  - php

---
[PHP Exceptions][1] can greatly assist in implementing various error scenario&#8217;s into an application. Before PHP5 one had to resort to specific return values or drastic measures like [trigger_error()][2]. Planning exceptions, I found out, is just as important as class design. At any point where a developer needs to handle the possibility of an exception being thrown he needs to know: 

  * What Exceptions can I expect?
  * What Exceptions do I plan to catch?

In this post I&#8217;ll show some important aspects to consider when planning exceptions.
  
<!--more-->

### The Basic Exception

Let&#8217;s assume a Soap-based web-service client class used to submit order-data to a supplier&#8217;s web-service. The web-service client throws an exception if required configuration parameters are missing. The actual SoapClient object will be initialized when the first webservice method is called.

Web-service client class:

<pre lang="php">class WsSoapClient
{
    private $config;
    private $soapClient = null;
    
    public function __construct($config) {
        $this->config = $config;
    }

    public function submitOrder(Order $order) {
        $this->initSoapClient();
        $this->soapClient->submitOrder($order->toSoapParam());
    }

    private function initSoapClient() {
        if (!is_null($this->soapClient)) {
            return;
        }
        if (!$this->config->wsdl) {
            throw new Exception('Configuration error');
        }
        $this->soapClient = new SoapClient($this->config->wsdl);
    }
}</pre>

Application code:

<pre lang="php">$config = Registry::get('config');
$client = new WsSoapClient($config);
try {
    $client->submitOrder($order);
} catch (Exception $e) {
    // We need to act on this asap...
    $AppError->register_error($e);
    // Redirect to application error page
    $Redirect->error($e);
}</pre>

In case of a configuration error a redirect is performed to an application-error page. And (just an example) some mechanism is triggered that starts to bug a (or all) developers that there&#8217;s a problem that needs immediate attention. 

### Knowing what to catch

There are of course errors that are less disastrous. Web-services can be down so we need to cope with that, resulting in the modifications below:

<pre lang="php">class WsSoapClientException extends Exception {}
class WsSoapClientConfigurationException extends WsSoapClientException{}
class WsSoapClientConnectionException extends WsSoapClientException{}

class WsSoapClient
{
    // ...
    private function initSoapClient() {
        if (!is_null($this->soapClient)) {
            return;
        }
        if (!$this->config->wsdl) {
            throw new WsSoapClientConfigurationException(
                'Configuration error'
            );
        }
        try {
            $this->soapClient = new SoapClient(
                $this->config->wsdl, 
                array('exceptions'=>1)
            );
        } catch (SoapFault $e) {
            throw new WsSoapClientConnectionException(
                'Cannot load WSDL: '.$this->config->wsdl
            );
        }
    }
}
</pre>

<pre lang="php">$client = new WsSoapClient($config);
try {
    $client->submitOrder($order);
} catch (WsSoapClientConnectionException $e) {
    // store the order in a queue to be processed later
    $Order->queue();
    $Redirect->Page('OrderQueued', $order);
} catch (Exception $e) {
    // Catch everything, also WsSoapClientConfigurationException
    
    // We need to act on this asap...
    $AppError->register_error($e);
    // Redirect to application error page
    $Redirect->error($e);
}
</pre>

Two things have changed:

#### Extending exception types

Exception classes have been defined for specific errors. They both extend an Exception class that is specific for the WsSoapClient class. This allows us to catch specific exceptions, like is done with WsSoapClientConnectionException. We could also catch all exceptions directly thrown by WsSoapClient by catching WsSoapClientException. When defining exception types one might take [SPL Exceptions][3] as a starting point.

#### Rethrowing exceptions

A SoapFault exception is caught and a WsSoapClientConnectionException is thrown instead. Now one might wonder: Why? Couldn&#8217;t I just as well catch SoapFault in the application code? That brings us to the next section.

### Knowing what to expect

In the previous example we simply used one WsSoapClient class to handle all web-service related communications. Now imagine that we have different suppliers that (inevitably) offer different types of web-services for us to use. Besides a client that handles Soap we now also need a client that handles XML-RPC.

After reading up a bit on [Design Patterns][4] we decide to introduce a [Factory][5] that returns the proper web-service client for the order, which we supply in the method call. 

<pre lang="php">class WsClientFactory
{
    static public function getWsClient(Order $order)
    {
        switch ($order->supplier) {
            case 'supplierA':
                return new WsSoapClient(
                    Registry::get('config')->soap->supplierA
                );
            case 'supplierB':
                return new WsXmlRpcClient(
                    Registry::get('config')->xmlrpc->supplierB
                );
        }
    }
}
</pre>

Briefly put: The point of a factory is to avoid the &#8216;new&#8217; keyword by allowing it to return various class instances. To know what callable methods to expect on the returned object, the possible object types need to implement a common interface or extend a common (abstract) class. We define an interface WsClient and let the two client types implement it:

<pre lang="php">interface WsClient
{
    public function submitOrder(Order $order);
}
class WsSoapClient implements WsClient
{
    public function submitOrder(Order $order)
    {
        // submitting order to soap webservice
    }
}
class WsXmlRpcClient implements WsClient
{
    public function submitOrder(Order $order)
    {
        // submitting order to xml-rpc webservice
    }
}
</pre>

Now if we take a look at our original application code it becomes obvious that we are not finished yet.

<pre lang="php">$client = WsClientFactory($order);
try {
    $client->submitOrder($order);
} catch (WsSoapClientConnectionException $e) {
    // Now what if there's a XML-RPC client throwing other exceptions?
}
</pre>

We could catch WsXmlRpcClientConnectException as well but that&#8217;s not the way to go for two obvious reasons:

  1. We would be duplicating the code in the catch blocks
  2. If later we need to add a WsEmailClient class, we would need to update both the factory and all the try-catch blocks in the application.

#### Abstracting exceptions

As the client types implement a common interface we can also define a set of exceptions that are thrown by all classes implementing that interface:

<pre lang="php">class WsClientException extends Exception {}
class WsClientConfigurationException extends WsClientException{}
class WsClientConnectionException extends WsClientException{}

interface WsClient
{
    public function submitOrder(Order $order);
}
</pre>

The classes implementing WsClient:

<pre lang="php">class WsSoapClient implements WsClient
{
    public function submitOrder(Order $order) {
        $this->initSoapClient();
        // ...
    }

    private function initSoapClient() {
        // Might throw: WsClientConfigurationException
        // Might throw: WsClientConnectionException
    }
}
class WsXmlRpcClient implements WsClient
{
    public function submitOrder(Order $order)
    {
        $this->initXmlRpcClient();
        // ...
    }

    private function initXmlRpcClient() {
        // Might throw: WsClientConfigurationException
        // Might throw: WsClientConnectionException
    }
}
</pre>

The application code retrieving an object from the factory now knows what exception types to expect:

<pre lang="php">$client = WsClientFactory($order);
try {
    $client->submitOrder($order);
} catch (WsClientConnectionException $e) {
    // Now we know what to expect
} catch (Exception $e) {
}
</pre>

### Wrapping it up

What the above shows is that:

  * Throwing a default &#8216;Exception&#8217; is bad practice if you ever want to act on that specific error scenario. Without extending the Exception class you can only catch all or none.
  * New exceptions can be thrown in catch blocks. That way it&#8217;s possible to prevent unexpected exception types to cross certain application design boundaries.
  * Once class design involves abstract classes or interfaces it is wise to design exception structures as well and organize them in similar layers of abstraction.

Using above &#8216;rules of thumb&#8217; will hopefully help in using exceptions to maximum effect. The above mainly covers the structure of exceptions and not so much functionally that can be added to an exception subclass. Ideas to consider:

  * Adding listeners to an Exception that might write exceptions to a log. Beware though: There&#8217;s probably no need to log &#8216;expected exceptions&#8217; and every disk-write is a small hit on performance.
  * Adding the caught exception to the new exception that is being re-thrown.

Do you think I&#8217;ve left out important parts or are you using (entirely) different exception strategies? Feel free to comment.

 [1]: http://us.php.net/manual/en/language.exceptions.php
 [2]: http://us.php.net/manual/en/function.trigger-error.php
 [3]: http://us.php.net/manual/en/spl.exceptions.php
 [4]: http://en.wikipedia.org/wiki/Design_pattern_%28computer_science%29
 [5]: http://www.ibm.com/developerworks/library/os-php-designptrns/#N10076