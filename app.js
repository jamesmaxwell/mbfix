Ext.Loader.setConfig({
			enabled : true
		});

Ext.application({
			name : 'Mbfix',
			appFolder : 'app',
			autoCreateViewport : true,

			statics : {
				/**
				 * 自定义属性, 当前登录用户名
				 * 
				 * @type string
				 */
				currentUser : null,

				/**
				 * 自定义属性, 当前登录服务点中文
				 * 
				 * @type
				 */
				currentServicePoint : null,

				/**
				 * 全局保存当前服务单编号
				 * 
				 * @type Number
				 */
				currentRecordId : 0
			},

			controllers : ['Home', 'User', 'Record', 'TypeAdmin', 'Repair', 'Finance']
		});