
import "widget.dart" ;
import "dart:html";

class UploadFileWidget extends Widget{
  
  
  UploadFileWidget(String id) : super(id){

    FileUploadInputElement inputFile = querySelector("#${id}-input") as FileUploadInputElement ; 
    Element link = querySelector("#${id}-link");
    Element info = querySelector("#${id}-info");
    ElementList infoList = querySelectorAll(".${id}-info");
    
    link.onClick.listen((e){
      inputFile.click();
    });
    
    inputFile.onChange.listen((e){
      if (inputFile.files.isNotEmpty){
        info.text = inputFile.files.first.name ;
        infoList.forEach((e){
          e.text = inputFile.files.first.name ;
        });
      }
    });
    
  }
  
  
  
}