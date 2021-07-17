<?php
return [
    'secret_key' => sha1(__FILE__), // 加密key
    'sign_key' => sha1(__FILE__), // 签名key
    'method' => 'AES-128-ECB'
];
