<?php
return [
    'drive' => 'file', // [file | redis] 调用Cache:: 相关方法使用的缓存驱动

    'file' => [
        'path' => _APP_PATH_ . '/RunCache/cache', //文件缓存位置
        'prefix' => 'one_' //文件前缀
    ],

    'redis' => [ // redis配置
        'default' => [  // 默认配置方法
            'max_connect_count' => 10, // 连接池最大数量
            'host' => '127.0.0.1',
            'port' => 6379,
            'prefix' => 'one_',
//            'auth' => '123456'
        ],
        'default_cluster' => [  // redis cluster 配置
            'max_connect_count' => 10, // 连接池最大数量
            'args' => [ //初始化参数
                null,
                ['192.168.1.10:7000','192.168.1.10:7001'],
                1.5,
                1.5,
                false,
                'password'
            ],
            'is_cluster' => true,
            'prefix' => 'one_',
//            'auth' => '123456'
        ]
    ]
];
