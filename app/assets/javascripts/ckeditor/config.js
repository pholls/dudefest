CKEDITOR.editorConfig = function( config ) {
  config.toolbar= [ 
    ['Cut','Copy','Paste','PasteText','PasteWord','-','Undo','Redo'],
    ['Find','Replace','-','SelectAll','-','Scayt'],
    ['Bold','Italic','Underline','Strike','-','RemoveFormat'],
    ['NumberedList','-','Outdent','Indent','-','Blockquote'],
    '/',
    ['Link','Unlink'],
    ['TextColor','BGColor'],
    ['Styles','Format'],
    ['Preview','Maximize']
  ];
  config.removePlugins = 'elementspath'
};
