Ext.define('Mbfix.model.ServiceRecord', {
	extend : 'Ext.data.Model',
	fields : [ {
				name : 'id',
				type : 'int'
			}, {
				name : 'user_id',
				type : 'int'
			}, {
				name : 'record_state',
				type : 'int'
			}, {
				name : 'create_time',
				type : 'date',
				dateFormat : 'U'
			}, {
				name : 'disk_state',
				type : 'int'
			},
			'name', 'service_point', 'record_no', 'custom_name', 'custom_type',
			'custom_sex', 'custom_mobile', 'custom_phone', 'custom_company',
			'custom_address', 'custom_postcode', 'custom_email',
			'service_type', 'machine_brand', 'machine_type', 'machine_model',
			'machine_snid', 'serial_number', 'warranty_type',
			'machine_look', 'machine_attachment', 'error_desc', 'other_note' ]
});