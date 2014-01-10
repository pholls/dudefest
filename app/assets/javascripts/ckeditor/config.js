CKEDITOR.editorConfig = function( config ) {
  config.toolbar= [ 
    ['Cut','Copy','Paste','PasteText','PasteWord','-','Undo','Redo'],
    ['Find','Replace','-','SelectAll','-','Scayt'],
    ['Bold','Italic','Underline','Strike','-','RemoveFormat'],
    '/',
    ['NumberedList','-','Blockquote'],
    ['Link','Unlink'],
    ['Styles','Format','Source'],
    ['Preview','Maximize']
  ];
  config.removePlugins = 'elementspath';
  config.enterMode = CKEDITOR.ENTER_DIV
};
