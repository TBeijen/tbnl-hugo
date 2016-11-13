---
title: Zend_Test, Zend_Layout and the need to reset
author: Tibo Beijen
date: 2009-06-01T11:55:30+00:00
url: /blog/2009/06/01/zend_test-zend_layout-and-the-need-to-reset/
postuserpic:
  - /zf_80.jpg
categories:
  - miscellaneous
tags:
  - php
  - unit testing
  - zend framework

---
In a recent Zend Framework project I&#8217;ve used Zend_Test to test the functioning of the website &#8216;as a whole&#8217;. So besides testing the separate (authorization) components, the website was tested in the same way a visitor would use it. This is especially useful for testing login scenarios, so I added the test below:

    public function testLogoutShouldDenyAccess()
    {
        $this->login();
    
             // verify that profile page now doesn't contain login form
        $this->dispatch('/profile');
        $this->assertQueryCount('form#login', 0);
    
            // dispatch logout page
        $this->dispatch('/login/logout');
    
            // verify that profile now holds login form
        $this->dispatch('/profile');
        $this->assertQueryCount('form#login', 1);
        $this->assertNotController('profile');
    }
    

This failed on the last assertQueryCount() which left me puzzled. Performing above steps manually seemed to work fine so I was overlooking something either in my app-code or the test-code.
  
<!--more-->


  
Adding a var_dump at the end of the test method gave some insight.

    var_dump($this->getResponse());

Showed a response object with a protected variable _body containing (simplified for clarity):

    
    
    
    
    
    <h1>
      login
    </h1>
        
        
        
        
    
    <h1>
      logout
    </h1>
        
        
    
    
    
    

Apparantly the total content of a previous request is prepended to the view part of the next request, resulting in incorrect html the assertQuery() method can&#8217;t handle. Looking into the login() helper method I made earlier:

    public function login()
    {
            //login
        $this->request->setMethod('POST')
             ->setPost(array(
                  'un' => 'testun',
                  'pw' => 'testpw'
             ));
        $this->dispatch('/login/login');
        $this->assertRedirectTo('/');
            // reset
        $this->resetRequest()
             ->resetResponse();
            // reset post
        $this->request->setPost(array());
    }
    

Apparently I forgot to reset the response object as adding that to the test method solved the issue. So for testing multiple requests in one test method one needs to reset the response to prevent incorrect html. This can be simplified by using below custom dispatch method that also allows setting POST data:

    public function doDispatch($url,$post=null)
    {
            // reset everything
        $this->resetRequest()
             ->resetResponse();
        $this->request->setPost(array());
    
            // add post-data if given
        if (is_array($post)) {
            $this->request->setMethod('POST');
            $this->request->setPost(array(
                'un' => 'testun',
                'pw' => 'testpw'
            ));
        }
    
            // dispatch
        $this->dispatch($url);
    }
    