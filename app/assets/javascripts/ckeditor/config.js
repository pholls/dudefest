CKEDITOR.editorConfig = function( config ) {
  config.toolbar= [ 
    ['Cut','Copy','Paste','PasteText','PasteWord','-','Undo','Redo'],
    ['Find','Replace','-','SelectAll','-','Scayt'],
    ['Bold','Italic','Underline','Strike','-','RemoveFormat'],
    '/',
    ['NumberedList','-','Blockquote'],
    ['Link','Unlink'],
    ['Styles','Format'],
    ['Preview','Maximize']
  ];
  config.height = 400;
  config.contentsCss = 'p { margin: 0px; padding: 0px; }';
};

