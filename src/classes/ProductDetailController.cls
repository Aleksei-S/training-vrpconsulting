global class ProductDetailController {
    public Product_Table__c product  {get; set;}
    public Contact contact {get; set;}
    public String message {get; set;}
    
    
    public ProductDetailController (){
        this.product = [
            SELECT Id, Name, Image_Url__c, Title__c, Product_Description__c, Unit_Price__c, Units_Available__c
            FROM Product_Table__c
            WHERE Id = :ApexPages.currentPage().getParameters().get('ProductId')];
        System.debug('product :'+ this.product);
    }
    
    public PageReference getPageCheckout (){
        System.debug('ParamValue :'+ ApexPages.currentPage().getParameters().get('ProductId'));
        PageReference ref = new PageReference('/apex/Checkout?ProductId='+ ApexPages.currentPage().getParameters().get('ProductId'));
        return ref;
    }
    
    
    public void Order(){
        this.contact  = ProductDetailController.CheckEMail(ApexPages.currentPage().getParameters().get('mail'));
        if(this.contact == null){
            this.contact =  new Contact(
                Email = ApexPages.currentPage().getParameters().get('mail'),
                FirstName = ApexPages.currentPage().getParameters().get('firstName'),
                LastName= ApexPages.currentPage().getParameters().get('lastname')); 
        } else {
            system.debug('DSADADA');
            system.debug(this.contact);
            this.contact.FirstName = ApexPages.currentPage().getParameters().get('firstName');
            this.contact.LastName= ApexPages.currentPage().getParameters().get('lastname');
        }
 
        Integer Count = integer.valueof(ApexPages.currentPage().getParameters().get('count'));
        
        try { 
            
            Product_Table__c available= [
                SELECT Units_Available__c
                FROM Product_Table__c
                WHERE Id= :product.Id]; 

            if (available.Units_Available__c - Count < 0) {
                this.message = 'error available only ' + available.Units_Available__c + ' units';
            } else {
                upsert this.contact;
                Order_Table__c Order = new Order_Table__c();
                Order.Product__c= product.id;
                Order.Units__c= Count;
                Order.Contact__c = this.contact.Id;
                Order.Order_Amount__c =  Order.Units__c * product.Unit_Price__c;
                
                system.debug(Order);
                available.Units_Available__c = available.Units_Available__c - Order.Units__c;
                insert Order;
                update available;     
                this.message = 'Order create succesfully';
            }
            
        } catch(DmlException e) {
            this.message = 'ERROR ' + e.getMessage();
        } 
        
    }
    
    
    
    
    @RemoteAction
    global static Contact CheckEMail(String mail){
        List<Contact> con= [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE Email= :mail]; 
        if(con.size() > 0){
            return con[0];
        } else {
            return null; 
        }        
    }  

    
    
    
}