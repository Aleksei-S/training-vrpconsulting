public class ProductTableController {
     
    
    public static List<Product_Table__c> getProductsList (){
        List <Product_Table__c> results = Database.query(
            'SELECT Id,Name,Image_Url__c,Title__c,Product_Description__c,Unit_Price__c '+
            'FROM Product_Table__c LIMIT 10');
        system.debug(results);
        return results;
    }
    

    public PageReference getPageProductDetails (){
        System.debug('ParamValue :'+ ApexPages.currentPage().getParameters().get('IdProductParam'));
        PageReference ref = new PageReference('/apex/ProductDetails?ProductId='+ ApexPages.currentPage().getParameters().get('IdProductParam'));
        ref.setRedirect(true);

        return ref;
    }
    
    
}