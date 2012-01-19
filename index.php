<?php
// change the following paths if necessary
$yii=dirname(__FILE__).'/../framework/yii.php';
$config=dirname(__FILE__).'/protected/config/main.php';

// remove the following lines when in production mode
//defined('YII_DEBUG') or define('YII_DEBUG',true);
// specify how many levels of call stack should be shown in each log message
defined('YII_TRACE_LEVEL') or define('YII_TRACE_LEVEL',3);

require_once($yii);
$app = Yii::createWebApplication($config);


$app->onError = function($event){
	$event->handled = true;

	while (ob_get_length())
		@ob_end_clean();

	if(!headers_sent())
		header("HTTP/1.0 500 PHP Error");
	echo $event->message;

};

$app->onException = function($event){
	$event->handled = true;
	
	while (ob_get_length())
		@ob_end_clean();

	$exception = $event->exception;
	if(!headers_sent())
		header("HTTP/1.0 {$exception->statusCode} " . get_class($exception));
	echo $exception->getMessage() . '<br/>';
	
	//TODO 返回json格式的字符串
	if(YII_DEBUG){
		echo $exception->getFile() . '<br/>';
		echo $exception->getLine() . '<br/>';
		echo nl2br($exception->getTraceAsString());
	}
};

$app->run();