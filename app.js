/**
 * 通用帮助类
 */
Ext.define('Mbfix.Util', {
			statics : {
				/**
				 * 默认的页面地址
				 */
				defaultPage : 'index.php',

				/**
				 * 根据控制器，动作和参数生成最终的URL地址
				 */
				getUrl : function(controller, action, parameter) {
					// TODO: 处理可能的参数
					return Ext.String.format('{0}?r={1}/{2}', this.defaultPage,
							controller, action);
				}
			}
		});

Ext.Loader.setConfig({
			enabled : true
		});

Ext.require(['Ext.button.Button', 'Ext.Component', 'Ext.container.Container',
		'Ext.grid.Panel', 'Ext.window.Window', 'Ext.form.Panel',
		'Ext.container.Viewport', 'Ext.toolbar.Toolbar', 'Ext.toolbar.Spacer',
		'Ext.form.FieldSet', 'Ext.form.field.ComboBox', 'Ext.form.field.Date',
		'Ext.form.field.Display', 'Ext.form.field.Hidden', 'Ext.form.Label',
		'Ext.form.field.Number', 'Ext.form.field.Radio',
		'Ext.form.field.TextArea', 'Ext.form.field.Text',
		'Ext.form.field.Checkbox', 'Ext.toolbar.Paging', 'Ext.toolbar.Fill',
		'Ext.toolbar.Item', 'Ext.toolbar.Separator', 'Ext.toolbar.TextItem',
		'Ext.view.View', 'Ext.menu.Menu', 'Ext.menu.Item',
		'Ext.menu.Separator', 'Ext.grid.plugin.Editing']);

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

			controllers : ['Home', 'User', 'Record', 'TypeAdmin', 'Repair',
					'Finance']
		});