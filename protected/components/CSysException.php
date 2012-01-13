<?php
/**
 * CSysException 系统中通用的异常类
 *
 * @author Junwei Hu
 */
class CSysException extends CException
{
	/**
	 * Constructor.
	 * @param string $message PDO error message
	 * @param integer $code PDO error code
	 */
	public function __construct($message,$code=0)
	{
		parent::__construct($message,$code);
	}
}