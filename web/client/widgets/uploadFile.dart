
import "widget.dart" ;
import "dart:html";

class UploadFileWidget extends Widget{
  
  
  UploadFileWidget(String id) : super(id){

    FileUploadInputElement inputFile = querySelector("#${id}-input") as FileUploadInputElement ; 
    Element link = querySelector("#${id}-link");
    Element info = querySelector("#${id}-info");
    
    link.onClick.listen((e){
      inputFile.click();
    });
    
    inputFile.onChange.listen((e){
      if (inputFile.files.isNotEmpty){
        info.text = inputFile.files.first.name ;
      }
    });
    
  }
  
  
  
}