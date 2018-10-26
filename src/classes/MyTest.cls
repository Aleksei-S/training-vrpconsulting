@isTest
public class MyTest {
    
    @isTest static void testGetProductsList() {
        Test.StartTest();
        Product_Table__c prod = new Product_Table__c(Name = 'forTest');
        insert  prod;
        List <Product_Table__c> zz = ProductTableController.getProductsList(); 
        system.assert(zz.size()>0);   
        Test.StopTest();
    }
    
    @isTest static void getPageProductDetails() {  
        Test.StartTest();
        PageReference pageCurrent = Page.ProductTablePage;
        Product_Table__c prod = new Product_Table__c(Name = 'forTest');
        insert prod;
        Test.setCurrentPage(pageCurrent);
        pageCurrent.getParameters().put('IdProductParam', prod.id);
        //system.debug(new ProductTableController().getPageProductDetails()); 
        PageReference pageRef =  new PageReference('/apex/ProductDetails?ProductId='+ prod.id);
        system.assertEquals(pageRef.getURL(), new ProductTableController().getPageProductDetails().getURL());
        //System.assertNotEquals(null, new ProductTableController().getPageProductDetails());
        Test.StopTest();
    }   
    
    @isTest static void ProductDetailController() {  
        Test.StartTest();
        Product_Table__c prod = new Product_Table__c(Name = 'forTest');
        insert prod;
        PageReference pageCurrent = Page.ProductTablePage;
        Test.setCurrentPage(pageCurrent);
        pageCurrent.getParameters().put('ProductId', prod.id);
        ProductDetailController controller = new ProductDetailController();
        //system.debug(controller.product);    
        System.assertEquals(controller.product.Name, 'forTest'); 
        Test.StopTest();
    }   
    
    @isTest static void getPageCheckout() {  
        Test.StartTest();
        PageReference pageCurrent = Page.ProductDetails;
        Product_Table__c prod = new Product_Table__c(Name = 'forTest');
        insert prod;
        Test.setCurrentPage(pageCurrent);
        pageCurrent.getParameters().put('ProductId', prod.id);
        PageReference pageRef =  new PageReference('/apex/Checkout?ProductId='+ prod.id);
        system.assertEquals(pageRef.getURL(), new ProductDetailController().getPageCheckout().getURL());
        Test.StopTest();
    } 
    
    
    @isTest static void OrderAvailableMoreThenCount() {  
        Test.StartTest();
        PageReference pageCurrent = Page.Checkout;
        Product_Table__c prod = new Product_Table__c(Name = 'forTest', Units_Available__c = 20, Unit_Price__c =50);
        insert prod;
        Test.setCurrentPage(pageCurrent);
        pageCurrent.getParameters().put('ProductId', prod.id);
        pageCurrent.getParameters().put('mail', 'forTest@mail.ru');
        pageCurrent.getParameters().put('firstName', 'TestName');
        pageCurrent.getParameters().put('lastname', 'TestLastName');
        pageCurrent.getParameters().put('count', '2');
        ProductDetailController controller = new ProductDetailController();
        controller.Order();
        //system.debug(controller.message); 
        system.assertEquals(controller.message, 'Order create succesfully');
        Test.StopTest();
    } 
    
    @isTest static void OrderCountMoreThenAvailable() {  
        Test.StartTest();
        PageReference pageCurrent = Page.Checkout;
        Product_Table__c prod = new Product_Table__c(Name = 'forTest', Units_Available__c = 20, Unit_Price__c =50);
        insert prod;
        Test.setCurrentPage(pageCurrent);
        pageCurrent.getParameters().put('ProductId', prod.id);
        pageCurrent.getParameters().put('mail', 'forTest@mail.ru');
        pageCurrent.getParameters().put('firstName', 'TestName');
        pageCurrent.getParameters().put('lastname', 'TestLastName');
        pageCurrent.getParameters().put('count', '40');
        ProductDetailController controller = new ProductDetailController();
        controller.Order();
        //system.debug(controller.message); 
        system.assertEquals(controller.message, 'error available only ' + prod.Units_Available__c + ' units');
        Test.StopTest();
    }   
    
    
    @isTest static void OrderDMLError() {  
        Test.StartTest();
        PageReference pageCurrent = Page.Checkout;
        Product_Table__c prod = new Product_Table__c(Name = 'forTest', Units_Available__c = 20, Unit_Price__c =50);
        insert prod;
        Test.setCurrentPage(pageCurrent);
        pageCurrent.getParameters().put('ProductId', prod.id);
        pageCurrent.getParameters().put('mail', 'forTest@mail.ru');
        pageCurrent.getParameters().put('firstName', '');
        pageCurrent.getParameters().put('lastname', '');
        pageCurrent.getParameters().put('count', '5');
        ProductDetailController controller = new ProductDetailController();
        controller.Order();
        system.debug(controller.message);    
        system.assertEquals(controller.message.left(5), 'ERROR');
        Test.StopTest();
    }
    
    @isTest static void OrderContactNotNull() {  
        
        Test.StartTest();
        PageReference pageCurrent = Page.Checkout;
        Product_Table__c prod = new Product_Table__c(Name = 'forTest', Units_Available__c = 20, Unit_Price__c =50);
        insert prod;
        Test.setCurrentPage(pageCurrent);
        pageCurrent.getParameters().put('ProductId', prod.id);
        ProductDetailController controller = new ProductDetailController();
        pageCurrent.getParameters().put('mail', 'forTest@mail.ru');
        pageCurrent.getParameters().put('firstName', 'TestName');
        pageCurrent.getParameters().put('lastname', 'TestLastName');
        pageCurrent.getParameters().put('count', '40');
        Contact con = new Contact(FirstName = 'ffff', LastName = 'ffff', Email = 'forTest@mail.ru');
        insert con;     
        controller.contact = con;
        controller.Order();
        Contact c = [
            SELECT Id, FirstName, LastName, Email
            FROM Contact]; 
        system.debug(c);
        system.assertEquals(controller.message, 'error available only ' + prod.Units_Available__c + ' units');
        Test.StopTest();
        
    } 
    
    
    @isTest static void CheckEMail() {  
        Test.StartTest();
        Contact conTest = new Contact(FirstName = 'Test', LastName = 'Test', Email = 'test@mail.ru');
        insert conTest;
        Contact con = ProductDetailController.CheckEMail('test@mail.ru');
        system.debug(con); 
        system.assertEquals(con.Email, 'test@mail.ru');
        Test.StopTest();
    }   
    
}