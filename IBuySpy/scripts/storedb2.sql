/*
Deployment script for Store
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


USE [master]

GO
:on error exit
GO
IF (DB_ID(N'Store') IS NOT NULL
    AND DATABASEPROPERTYEX(N'Store','Status') <> N'ONLINE')
BEGIN
    RAISERROR(N'The state of the target database, %s, is not set to ONLINE. To deploy to this database, its state must be set to ONLINE.', 16, 127,N'Store') WITH NOWAIT
    RETURN
END

GO
IF (DB_ID(N'Store') IS NOT NULL) 
BEGIN
    ALTER DATABASE [Store]
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [Store];
END

GO
PRINT N'Creating Store...'
GO
CREATE DATABASE [Store]
   
GO
EXECUTE sp_dbcmptlevel [Store], 100;


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'Store')
    BEGIN
        ALTER DATABASE [Store]
            SET ANSI_NULLS ON,
                ANSI_PADDING ON,
                ANSI_WARNINGS ON,
                ARITHABORT ON,
                CONCAT_NULL_YIELDS_NULL ON,
                NUMERIC_ROUNDABORT OFF,
                QUOTED_IDENTIFIER ON,
                ANSI_NULL_DEFAULT ON,
                CURSOR_DEFAULT LOCAL,
                RECOVERY FULL,
                CURSOR_CLOSE_ON_COMMIT OFF,
                AUTO_CREATE_STATISTICS ON,
                AUTO_SHRINK OFF,
                AUTO_UPDATE_STATISTICS ON,
                RECURSIVE_TRIGGERS OFF 
            WITH ROLLBACK IMMEDIATE;
        ALTER DATABASE [Store]
            SET AUTO_CLOSE OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'Store')
    BEGIN
        ALTER DATABASE [Store]
            SET ALLOW_SNAPSHOT_ISOLATION OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'Store')
    BEGIN
        ALTER DATABASE [Store]
            SET READ_COMMITTED_SNAPSHOT OFF;
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'Store')
    BEGIN
        ALTER DATABASE [Store]
            SET AUTO_UPDATE_STATISTICS_ASYNC OFF,
                PAGE_VERIFY NONE,
                DATE_CORRELATION_OPTIMIZATION OFF,
                DISABLE_BROKER,
                PARAMETERIZATION SIMPLE,
                SUPPLEMENTAL_LOGGING OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'Store')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [Store]
    SET TRUSTWORTHY OFF,
        DB_CHAINING OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings for DB_CHAINING or TRUSTWORTHY cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
IF EXISTS (SELECT 1
           FROM   [master].[dbo].[sysdatabases]
           WHERE  [name] = N'Store')
    BEGIN
        ALTER DATABASE [Store]
            SET HONOR_BROKER_PRIORITY OFF 
            WITH ROLLBACK IMMEDIATE;
    END


GO
USE [Store]

GO
IF fulltextserviceproperty(N'IsFulltextInstalled') = 1
    EXECUTE sp_fulltext_database 'enable';


GO
/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

GO
PRINT N'Creating NT AUTHORITY\NETWORK SERVICE...';


GO
CREATE USER [NT AUTHORITY\NETWORK SERVICE];


GO
PRINT N'Creating <unnamed>...';


GO
EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'NT AUTHORITY\NETWORK SERVICE';


GO
PRINT N'Creating NT AUTHORITY\NETWORK SERVICE...';


GO
CREATE SCHEMA [NT AUTHORITY\NETWORK SERVICE]
    AUTHORIZATION [NT AUTHORITY\NETWORK SERVICE];


GO
PRINT N'Creating dbo.Categories...';


GO
CREATE TABLE [dbo].[Categories] (
    [CategoryID]   INT           IDENTITY (1, 1) NOT NULL,
    [CategoryName] NVARCHAR (50) NULL
);


GO
PRINT N'Creating dbo.PK_Categories...';


GO
ALTER TABLE [dbo].[Categories]
    ADD CONSTRAINT [PK_Categories] PRIMARY KEY NONCLUSTERED ([CategoryID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating dbo.Customers...';


GO
CREATE TABLE [dbo].[Customers] (
    [CustomerID]   INT           IDENTITY (1, 1) NOT NULL,
    [FullName]     NVARCHAR (50) NULL,
    [EmailAddress] NVARCHAR (50) NULL,
    [Password]     NVARCHAR (50) NULL
);


GO
PRINT N'Creating dbo.PK_Customers...';


GO
ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [PK_Customers] PRIMARY KEY NONCLUSTERED ([CustomerID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating dbo.IX_Customers...';


GO
ALTER TABLE [dbo].[Customers]
    ADD CONSTRAINT [IX_Customers] UNIQUE NONCLUSTERED ([EmailAddress] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating dbo.OrderDetails...';


GO
CREATE TABLE [dbo].[OrderDetails] (
    [OrderID]   INT   NOT NULL,
    [ProductID] INT   NOT NULL,
    [Quantity]  INT   NOT NULL,
    [UnitCost]  MONEY NOT NULL
);


GO
PRINT N'Creating dbo.PK_OrderDetails...';


GO
ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [PK_OrderDetails] PRIMARY KEY NONCLUSTERED ([OrderID] ASC, [ProductID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating dbo.Orders...';


GO
CREATE TABLE [dbo].[Orders] (
    [OrderID]    INT      IDENTITY (1, 1) NOT NULL,
    [CustomerID] INT      NOT NULL,
    [OrderDate]  DATETIME NOT NULL,
    [ShipDate]   DATETIME NOT NULL
);


GO
PRINT N'Creating dbo.PK_Orders...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [PK_Orders] PRIMARY KEY NONCLUSTERED ([OrderID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating dbo.Products...';


GO
CREATE TABLE [dbo].[Products] (
    [ProductID]    INT             IDENTITY (1, 1) NOT NULL,
    [CategoryID]   INT             NOT NULL,
    [ModelNumber]  NVARCHAR (50)   NULL,
    [ModelName]    NVARCHAR (50)   NULL,
    [ProductImage] NVARCHAR (50)   NULL,
    [UnitCost]     MONEY           NOT NULL,
    [Description]  NVARCHAR (3800) NULL
);


GO
PRINT N'Creating dbo.PK_Products...';


GO
ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [PK_Products] PRIMARY KEY NONCLUSTERED ([ProductID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating dbo.QuantityDiscounts...';


GO
CREATE TABLE [dbo].[QuantityDiscounts] (
    [ProductId]             INT   NOT NULL,
    [QuantityDiscount]      FLOAT NOT NULL,
    [QuantityDiscountLevel] INT   NOT NULL
);


GO
PRINT N'Creating dbo.Reviews...';


GO
CREATE TABLE [dbo].[Reviews] (
    [ReviewID]      INT             IDENTITY (1, 1) NOT NULL,
    [ProductID]     INT             NOT NULL,
    [CustomerName]  NVARCHAR (50)   NULL,
    [CustomerEmail] NVARCHAR (50)   NULL,
    [Rating]        INT             NOT NULL,
    [Comments]      NVARCHAR (3850) NULL
);


GO
PRINT N'Creating dbo.ShoppingCart...';


GO
CREATE TABLE [dbo].[ShoppingCart] (
    [RecordID]    INT           IDENTITY (1, 1) NOT NULL,
    [CartID]      NVARCHAR (50) NULL,
    [Quantity]    INT           NOT NULL,
    [ProductID]   INT           NOT NULL,
    [DateCreated] DATETIME      NOT NULL,
    [UnitCost]    MONEY         NULL
);


GO
PRINT N'Creating dbo.PK_ShoppingCart...';


GO
ALTER TABLE [dbo].[ShoppingCart]
    ADD CONSTRAINT [PK_ShoppingCart] PRIMARY KEY NONCLUSTERED ([RecordID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);


GO
PRINT N'Creating dbo.ShoppingCart.IX_ShoppingCart...';


GO
CREATE NONCLUSTERED INDEX [IX_ShoppingCart]
    ON [dbo].[ShoppingCart]([CartID] ASC, [ProductID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);


GO
PRINT N'Creating dbo.DF_Orders_OrderDate...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_OrderDate] DEFAULT (getdate()) FOR [OrderDate];


GO
PRINT N'Creating dbo.DF_Orders_ShipDate...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [DF_Orders_ShipDate] DEFAULT (getdate()) FOR [ShipDate];


GO
PRINT N'Creating dbo.DF_ShoppingCart_DateCreated...';


GO
ALTER TABLE [dbo].[ShoppingCart]
    ADD CONSTRAINT [DF_ShoppingCart_DateCreated] DEFAULT (getdate()) FOR [DateCreated];


GO
PRINT N'Creating dbo.DF_ShoppingCart_Quantity...';


GO
ALTER TABLE [dbo].[ShoppingCart]
    ADD CONSTRAINT [DF_ShoppingCart_Quantity] DEFAULT ((1)) FOR [Quantity];


GO
PRINT N'Creating dbo.FK_OrderDetails_Orders...';


GO
ALTER TABLE [dbo].[OrderDetails]
    ADD CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Orders] ([OrderID]) ON DELETE NO ACTION ON UPDATE NO ACTION NOT FOR REPLICATION;


GO
PRINT N'Creating dbo.FK_Orders_Customers...';


GO
ALTER TABLE [dbo].[Orders]
    ADD CONSTRAINT [FK_Orders_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([CustomerID]) ON DELETE NO ACTION ON UPDATE NO ACTION NOT FOR REPLICATION;


GO
PRINT N'Creating dbo.FK_Products_Categories...';


GO
ALTER TABLE [dbo].[Products]
    ADD CONSTRAINT [FK_Products_Categories] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Categories] ([CategoryID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating dbo.FK_Reviews_Products...';


GO
ALTER TABLE [dbo].[Reviews]
    ADD CONSTRAINT [FK_Reviews_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE NO ACTION ON UPDATE NO ACTION NOT FOR REPLICATION;


GO
PRINT N'Creating dbo.FK_ShoppingCart_Products...';


GO
ALTER TABLE [dbo].[ShoppingCart]
    ADD CONSTRAINT [FK_ShoppingCart_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID]) ON DELETE NO ACTION ON UPDATE NO ACTION;


GO
PRINT N'Creating dbo.CustomerAdd...';


GO
SET QUOTED_IDENTIFIER ON;

SET ANSI_NULLS OFF;


GO

CREATE Procedure CustomerAdd
(
    @FullName   nvarchar(50),
    @Email      nvarchar(50),
    @Password   nvarchar(50),
    @CustomerID int OUTPUT
)
AS

INSERT INTO Customers
(
    FullName,
    EMailAddress,
    Password
)

VALUES
(
    @FullName,
    @Email,
    @Password
)

SELECT
    @CustomerID = @@Identity


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating dbo.CustomerAlsoBought...';


GO

CREATE Procedure CustomerAlsoBought
(
    @ProductID int
)
As

/* We want to take the top 5 products contained in
    the orders where someone has purchased the given Product */
SELECT  TOP 5 
    OrderDetails.ProductID,
    Products.ModelName,
    SUM(OrderDetails.Quantity) as TotalNum

FROM    
    OrderDetails
  INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID

WHERE   OrderID IN 
(
    /* This inner query should retrieve all orders that have contained the productID */
    SELECT DISTINCT OrderID 
    FROM OrderDetails
    WHERE ProductID = @ProductID
)
AND OrderDetails.ProductID != @ProductID 

GROUP BY OrderDetails.ProductID, Products.ModelName 

ORDER BY TotalNum DESC


GO
PRINT N'Creating dbo.CustomerDetail...';


GO

CREATE Procedure CustomerDetail
(
    @CustomerID int,
    @FullName   nvarchar(50) OUTPUT,
    @Email      nvarchar(50) OUTPUT,
    @Password   nvarchar(50) OUTPUT
)
AS

SELECT 
    @FullName = FullName, 
    @Email    = EmailAddress, 
    @Password = Password

FROM 
    Customers

WHERE 
    CustomerID = @CustomerID

GO
PRINT N'Creating dbo.CustomerLogin...';


GO

CREATE Procedure CustomerLogin
(
    @Email      nvarchar(50),
    @Password   nvarchar(50),
    @CustomerID int OUTPUT
)
AS

SELECT 
    @CustomerID = CustomerID
    
FROM 
    Customers
    
WHERE 
    EmailAddress = @Email
  AND 
    Password = @Password

IF @@Rowcount < 1 
SELECT 
    @CustomerID = 0

GO
PRINT N'Creating dbo.OrdersDetail...';


GO

CREATE Procedure OrdersDetail
(
    @OrderID    int,
    @CustomerID int,
    @OrderDate  datetime OUTPUT,
    @ShipDate   datetime OUTPUT,
    @OrderTotal money OUTPUT
)
AS

/* Return the order dates from the Orders
    Also verifies the order exists for this customer. */
SELECT 
    @OrderDate = OrderDate,
    @ShipDate = ShipDate
    
FROM    
    Orders
    
WHERE   
    OrderID = @OrderID
    AND
    CustomerID = @CustomerID

IF @@Rowcount = 1
BEGIN

/* First, return the OrderTotal out param */
SELECT  
    @OrderTotal = Cast(SUM(OrderDetails.Quantity * OrderDetails.UnitCost) as money)
    
FROM    
    OrderDetails
    
WHERE   
    OrderID= @OrderID

/* Then, return the recordset of info */
SELECT  
    Products.ProductID, 
    Products.ModelName,
    Products.ModelNumber,
    OrderDetails.UnitCost,
    OrderDetails.Quantity,
    (OrderDetails.Quantity * OrderDetails.UnitCost) as ExtendedAmount

FROM
    OrderDetails
  INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
  
WHERE   
    OrderID = @OrderID

END


GO
PRINT N'Creating dbo.OrdersList...';


GO

CREATE Procedure OrdersList
(
    @CustomerID int
)
As

SELECT  
    Orders.OrderID,
    Cast(sum(orderdetails.quantity*orderdetails.unitcost) as money) as OrderTotal,
    Orders.OrderDate, 
    Orders.ShipDate

FROM    
    Orders 
  INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID

GROUP BY    
    CustomerID, 
    Orders.OrderID, 
    Orders.OrderDate, 
    Orders.ShipDate
HAVING  
    Orders.CustomerID = @CustomerID


GO
PRINT N'Creating dbo.ProductCategoryList...';


GO

CREATE Procedure ProductCategoryList

AS

SELECT 
    CategoryID,
    CategoryName

FROM 
    Categories

ORDER BY 
    CategoryName ASC


GO
PRINT N'Creating dbo.ProductDetail...';


GO

CREATE Procedure ProductDetail
(
    @ProductID    int,
    @ModelNumber  nvarchar(50) OUTPUT,
    @ModelName    nvarchar(50) OUTPUT,
    @ProductImage nvarchar(50) OUTPUT,
    @UnitCost     money OUTPUT,
    @Description  nvarchar(4000) OUTPUT
)
AS

SELECT 
    @ProductID    = ProductID,
    @ModelNumber  = ModelNumber,
    @ModelName    = ModelName,
    @ProductImage = ProductImage,
    @UnitCost     = UnitCost,
    @Description  = Description

FROM 
    Products

WHERE 
    ProductID = @ProductID

GO
PRINT N'Creating dbo.ProductsByCategory...';


GO

CREATE Procedure ProductsByCategory
(
    @CategoryID int
)
AS

SELECT 
    ProductID,
    ModelName,
    UnitCost, 
    ProductImage

FROM 
    Products

WHERE 
    CategoryID = @CategoryID

ORDER BY 
    ModelName, 
    ModelNumber


GO
PRINT N'Creating dbo.ProductSearch...';


GO

CREATE Procedure ProductSearch
(
    @Search nvarchar(255)
)
AS

SELECT 
    ProductID,
    ModelName,
    ModelNumber,
    UnitCost, 
    ProductImage

FROM 
    Products

WHERE 
    ModelNumber LIKE '%' + @Search + '%' 
   OR
    ModelName LIKE '%' + @Search + '%'
   OR
    Description LIKE '%' + @Search + '%'

GO
PRINT N'Creating dbo.ProductsMostPopular...';


GO

CREATE Procedure ProductsMostPopular

AS

SELECT TOP 5 
    OrderDetails.ProductID, 
    SUM(OrderDetails.Quantity) as TotalNum, 
    Products.ModelName
    
FROM    
    OrderDetails
  INNER JOIN Products ON OrderDetails.ProductID = Products.ProductID
  
GROUP BY 
    OrderDetails.ProductID, 
    Products.ModelName
    
ORDER BY 
    TotalNum DESC


GO
PRINT N'Creating dbo.QuantityDiscountsList...';


GO

Create Procedure [dbo].[QuantityDiscountsList]
AS

SELECT 
    ProductId,
    QuantityDiscount,
    QuantityDiscountLevel
FROM 
   QuantityDiscounts

GO
PRINT N'Creating dbo.ReviewsAdd...';


GO
SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER OFF;


GO

CREATE Procedure ReviewsAdd
(
    @ProductID     int,
    @CustomerName  nvarchar(50),
    @CustomerEmail nvarchar(50),
    @Rating        int,
    @Comments      nvarchar(3850),
    @ReviewID      int OUTPUT
)
AS

INSERT INTO Reviews
(
    ProductID, 
    CustomerName, 
    CustomerEmail, 
    Rating, 
    Comments
)
VALUES
(
    @ProductID, 
    @CustomerName, 
    @CustomerEmail, 
    @Rating, 
    @Comments
)

SELECT 
    @ReviewID = @@Identity


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating dbo.ReviewsList...';


GO
SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER OFF;


GO

CREATE Procedure ReviewsList
(
    @ProductID int
)
AS

SELECT 
    ReviewID, 
    CustomerName, 
    Rating, 
    Comments
    
FROM 
    Reviews
    
WHERE 
    ProductID = @ProductID


GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON;


GO
PRINT N'Creating dbo.ShoppingCartAddItem...';


GO

CREATE Procedure [dbo].[ShoppingCartAddItem]
(
    @CartID nvarchar(50),
    @ProductID int,
    @Quantity int
)
As

DECLARE @CountItems int

SELECT
    @CountItems = Count(ProductID)
FROM
    ShoppingCart
WHERE
    ProductID = @ProductID
  AND
    CartID = @CartID

IF @CountItems > 0  /* There are items - update the current quantity */

    UPDATE
        ShoppingCart
    SET
        Quantity = (@Quantity + ShoppingCart.Quantity)
    WHERE
        ProductID = @ProductID
      AND
        CartID = @CartID

ELSE  /* New entry for this Cart.  Add a new record */
	declare @UnitCost money;
	Select @UnitCost = UnitCost From Products WHERE ProductId = @ProductId
    INSERT INTO ShoppingCart
    (
        CartID,
        Quantity,
        ProductID,
        UnitCost
    )
    VALUES
    (
        @CartID,
        @Quantity,
        @ProductID,
        @UnitCost
    )
GO
PRINT N'Creating dbo.ShoppingCartEmpty...';


GO

CREATE Procedure ShoppingCartEmpty
(
    @CartID nvarchar(50)
)
AS

DELETE FROM ShoppingCart

WHERE 
    CartID = @CartID

GO
PRINT N'Creating dbo.ShoppingCartItemCount...';


GO

CREATE Procedure ShoppingCartItemCount
(
    @CartID    nvarchar(50),
    @ItemCount int OUTPUT
)
AS

SELECT 
    @ItemCount = COUNT(ProductID)
    
FROM 
    ShoppingCart
    
WHERE 
    CartID = @CartID

GO
PRINT N'Creating dbo.ShoppingCartList...';


GO

CREATE Procedure [dbo].[ShoppingCartList]
(
    @CartID nvarchar(50)
)
AS

SELECT 
    Products.ProductID, 
    Products.ModelName,
    Products.ModelNumber,
    ShoppingCart.Quantity,
    ShoppingCart.UnitCost,
    Cast((ShoppingCart.UnitCost * ShoppingCart.Quantity) as money) as ExtendedAmount

FROM 
    Products,
    ShoppingCart

WHERE 
    Products.ProductID = ShoppingCart.ProductID
  AND 
    ShoppingCart.CartID = @CartID

ORDER BY 
    Products.ModelName, 
    Products.ModelNumber
GO
PRINT N'Creating dbo.ShoppingCartMigrate...';


GO

CREATE Procedure ShoppingCartMigrate
(
    @OriginalCartId nvarchar(50),
    @NewCartId      nvarchar(50)
)
AS

UPDATE 
    ShoppingCart
    
SET 
    CartId = @NewCartId 
    
WHERE 
    CartId = @OriginalCartId

GO
PRINT N'Creating dbo.ShoppingCartRemoveAbandoned...';


GO

CREATE Procedure ShoppingCartRemoveAbandoned

AS

DELETE FROM ShoppingCart

WHERE 
    DATEDIFF(dd, DateCreated, GetDate()) > 1


GO
PRINT N'Creating dbo.ShoppingCartRemoveItem...';


GO

CREATE Procedure ShoppingCartRemoveItem
(
    @CartID nvarchar(50),
    @ProductID int
)
AS

DELETE FROM ShoppingCart

WHERE 
    CartID = @CartID
  AND
    ProductID = @ProductID


GO
PRINT N'Creating dbo.ShoppingCartTotal...';


GO

CREATE Procedure ShoppingCartTotal
(
    @CartID    nvarchar(50),
    @TotalCost money OUTPUT
)
AS

SELECT 
    @TotalCost = SUM(Products.UnitCost * ShoppingCart.Quantity)

FROM 
    ShoppingCart,
    Products

WHERE
    ShoppingCart.CartID = @CartID
  AND
    Products.ProductID = ShoppingCart.ProductID

GO
PRINT N'Creating dbo.ShoppingCartUpdate...';


GO

CREATE Procedure [dbo].[ShoppingCartUpdate]
(
    @CartID    nvarchar(50),
    @ProductID int,
    @Quantity  int
)
AS

UPDATE ShoppingCart

SET 
    Quantity = @Quantity

WHERE 
    CartID = @CartID 
  AND 
    ProductID = @ProductID

GO
PRINT N'Creating dbo.UpdateQuantityDiscount...';


GO

Create Procedure [dbo].[UpdateQuantityDiscount]
(
    @CartID    nvarchar(50),
    @ProductID int,
    @UnitCost  money
)
AS

UPDATE ShoppingCart

SET 
    UnitCost = @UnitCost

WHERE 
    CartID = @CartID 
  AND 
    ProductID = @ProductID

GO
PRINT N'Creating dbo.OrdersAdd...';


GO


CREATE Procedure [dbo].[OrdersAdd]
(
    @CustomerID int,
    @CartID     nvarchar(50),
    @OrderDate  datetime,        
    @ShipDate   datetime,
    @OrderID    int OUTPUT
)
AS

BEGIN TRAN AddOrder

/* Create the Order header */
INSERT INTO Orders
(
    CustomerID, 
    OrderDate, 
    ShipDate
)
VALUES
(   
    @CustomerID, 
    @OrderDate, 
    @ShipDate
)

SELECT
    @OrderID = @@Identity    

/* Copy items from given shopping cart to OrdersDetail table for given OrderID*/
INSERT INTO OrderDetails
(
    OrderID, 
    ProductID, 
    Quantity, 
    UnitCost
)

SELECT 
    @OrderID, 
    ShoppingCart.ProductID, 
    Quantity, 
    ShoppingCart.UnitCost

FROM 
    ShoppingCart 
  INNER JOIN Products ON ShoppingCart.ProductID = Products.ProductID
  
WHERE 
    CartID = @CartID

/* Removal of  items from user's shopping cart will happen on the business layer*/
EXEC ShoppingCartEmpty @CartId

COMMIT TRAN AddOrder


GO
-- Refactoring step to update target server with deployed transaction logs
CREATE TABLE  __RefactorLog (OperationKey UNIQUEIDENTIFIER NOT NULL PRIMARY KEY)
GO
sp_addextendedproperty N'microsoft_database_tools_support', N'refactoring log', N'schema', N'dbo', N'table', N'__RefactorLog'
GO

GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

-- =======================================================
-- INSERT INITIAL DATA INTO IBUYSPY Store DB
-- =======================================================

-- point to proper DB 
use [Store]
GO

SET IDENTITY_INSERT Categories ON
GO

INSERT INTO Categories (CategoryID,CategoryName) VALUES (14,'Communications')
INSERT INTO Categories (CategoryID,CategoryName) VALUES (15,'Deception')
INSERT INTO Categories (CategoryID,CategoryName) VALUES (16,'Travel')
INSERT INTO Categories (CategoryID,CategoryName) VALUES (17,'Protection')
INSERT INTO Categories (CategoryID,CategoryName) VALUES (18,'Munitions')
INSERT INTO Categories (CategoryID,CategoryName) VALUES (19,'Tools')
INSERT INTO Categories (CategoryID,CategoryName) VALUES (20,'General')
GO

SET IDENTITY_INSERT Categories OFF
GO


SET IDENTITY_INSERT Customers ON
GO

INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (1,'James Bondwell','jb@ibuyspy.com','IBS_007')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (2,'Sarah Goodpenny','sg@ibuyspy.com','IBS_001')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (3,'Gordon Que','gq@ibuyspy.com','IBS_000')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (19,'Guest Account','guest','guest')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (16,'Test Account','d','d')
GO

SET IDENTITY_INSERT Customers OFF
GO

SET IDENTITY_INSERT Orders ON
GO

INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (99,19,'2000-07-06 01:01:00.000','2000-07-07 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (93,16,'2000-07-03 01:01:00.000','2000-07-04 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (101,16,'2000-07-10 01:01:00.000','2000-07-11 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (103,16,'2000-07-10 01:01:00.000','2000-07-10 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (96,19,'2000-07-03 01:01:00.000','2000-07-03 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (104,19,'2000-07-10 01:01:00.000','2000-07-11 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (105,16,'2000-10-30 01:01:00.000','2000-10-31 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (106,16,'2000-10-30 01:01:00.000','2000-10-30 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (107,16,'2000-10-30 01:01:00.000','2000-10-31 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (100,19,'2000-07-06 01:01:00.000','2000-07-08 01:01:00.000')
INSERT INTO Orders (OrderID,CustomerID,OrderDate,ShipDate) VALUES (102,16,'2000-07-10 01:01:00.000','2000-07-12 01:01:00.000')
GO


SET IDENTITY_INSERT Orders OFF
GO

INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (99,404,2,459.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (93,363,1,1.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (101,378,2,14.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (102,372,1,129.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (96,378,1,14.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (103,363,1,1.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (104,355,1,1499.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (104,378,1,14.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (104,406,1,399.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (100,404,2,459.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (101,401,1,599.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (102,401,1,599.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (104,362,1,1.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (104,404,1,459.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (105,355,2,1499.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (106,401,1,599.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (106,404,2,459.99)
INSERT INTO OrderDetails (OrderID,ProductID,Quantity,UnitCost) VALUES (107,368,2,19999.98)
GO


SET IDENTITY_INSERT Products ON
GO

INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (355,16,'RU007','Rain Racer 2000','image.gif',1499.99,'Looks like an ordinary bumbershoot, but don''t be fooled! Simply place Rain Racer''s tip on the ground and press the release latch. Within seconds, this ordinary rain umbrella converts into a two-wheeled gas-powered mini-scooter. Goes from 0 to 60 in 7.5 seconds - even in a driving rain! Comes in black, blue, and candy-apple red.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (356,20,'STKY1','Edible Tape','image.gif',3.99,'The latest in personal survival gear, the STKY1 looks like a roll of ordinary office tape, but can save your life in an emergency.  Just remove the tape roll and place in a kettle of boiling water with mixed vegetables and a ham shank. In just 90 minutes you have a great tasking soup that really sticks to your ribs! Herbs and spices not included.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (357,16,'P38','Escape Vehicle (Air)','image.gif',2.99,'In a jam, need a quick escape? Just whip out a sheet of our patented P38 paper and, with a few quick folds, it converts into a lighter-than-air escape vehicle! Especially effective on windy days - no fuel required. Comes in several sizes including letter, legal, A10, and B52.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (358,19,'NOZ119','Extracting Tool','image.gif',199,'High-tech miniaturized extracting tool. Excellent for extricating foreign objects from your person. Good for picking up really tiny stuff, too! Cleverly disguised as a pair of tweezers. ')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (359,16,'PT109','Escape Vehicle (Water)','image.gif',1299.99,'Camouflaged as stylish wing tips, these shoes get you out of a jam on the high seas instantly. Exposed to water, the pair transforms into speedy miniature inflatable rafts. Complete with 76 HP outboard motor, these hip heels will whisk you to safety even in the roughest of seas. Warning: Not recommended for beachwear.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (360,14,'RED1','Communications Device','image.gif',49.99,'Subversively stay in touch with this miniaturized wireless communications device. Speak into the pointy end and listen with the other end! Voice-activated dialing makes calling for backup a breeze. Excellent for undercover work at schools, rest homes, and most corporate headquarters. Comes in assorted colors.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (362,14,'LK4TLNT','Persuasive Pencil','image.gif',1.99,'Persuade anyone to see your point of view!  Captivate your friends and enemies alike!  Draw the crime-scene or map out the chain of events.  All you need is several years of training or copious amounts of natural talent. You''re halfway there with the Persuasive Pencil. Purchase this item with the Retro Pocket Protector Rocket Pack for optimum disguise.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (363,18,'NTMBS1','Multi-Purpose Rubber Band','image.gif',1.99,'One of our most popular items!  A band of rubber that stretches  20 times the original size. Uses include silent one-to-one communication across a crowded room, holding together a pack of Persuasive Pencils, and powering lightweight aircraft. Beware, stretching past 20 feet results in a painful snap and a rubber strip.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (364,19,'NE1RPR','Universal Repair System','image.gif',4.99,'Few people appreciate the awesome repair possibilities contained in a single roll of duct tape. In fact, some houses in the Midwest are made entirely out of the miracle material contained in every roll! Can be safely used to repair cars, computers, people, dams, and a host of other items.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (365,19,'BRTLGT1','Effective Flashlight','image.gif',9.99,'The most powerful darkness-removal device offered to creatures of this world.  Rather than amplifying existing/secondary light, this handy product actually REMOVES darkness allowing you to see with your own eyes.  Must-have for nighttime operations. An affordable alternative to the Night Vision Goggles.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (367,18,'INCPPRCLP','The Incredible Versatile Paperclip','image.gif',1.49,'This 0. 01 oz piece of metal is the most versatile item in any respectable spy''s toolbox and will come in handy in all sorts of situations. Serves as a wily lock pick, aerodynamic projectile (used in conjunction with Multi-Purpose Rubber Band), or escape-proof finger cuffs.  Best of all, small size and pliability means it fits anywhere undetected.  Order several today!')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (368,16,'DNTRPR','Toaster Boat','image.gif',19999.98,'Turn breakfast into a high-speed chase! In addition to toasting bagels and breakfast pastries, this inconspicuous toaster turns into a speedboat at the touch of a button. Boasting top speeds of 60 knots and an ultra-quiet motor, this valuable item will get you where you need to be ... fast! Best of all, Toaster Boat is easily repaired using a Versatile Paperclip or a standard butter knife. Manufacturer''s Warning: Do not submerge electrical items.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (370,17,'TGFDA','Multi-Purpose Towelette','image.gif',12.99,'Don''t leave home without your monogrammed towelette! Made from lightweight, quick-dry fabric, this piece of equipment has more uses in a spy''s day than a Swiss Army knife. The perfect all-around tool while undercover in the locker room: serves as towel, shield, disguise, sled, defensive weapon, whip and emergency food source. Handy bail gear for the Toaster Boat. Monogram included with purchase price.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (371,18,'WOWPEN','Mighty Mighty Pen','image.gif',129.99,'Some spies claim this item is more powerful than a sword. After examining the titanium frame, built-in blowtorch, and Nerf dart-launcher, we tend to agree! ')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (372,20,'ICNCU','Perfect-Vision Glasses','image.gif',129.99,'Avoid painful and potentially devastating laser eye surgery and contact lenses. Cheaper and more effective than a visit to the optometrist, these Perfect-Vision Glasses simply slide over nose and eyes and hook on ears. Suddenly you have 20/20 vision! Glasses also function as HUD (Heads Up Display) for most European sports cars manufactured after 1992.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (373,17,'LKARCKT','Pocket Protector Rocket Pack','image.gif',1.99,'Any debonair spy knows that this accoutrement is coming back in style. Flawlessly protects the pockets of your short-sleeved oxford from unsightly ink and pencil marks. But there''s more! Strap it on your back and it doubles as a rocket pack. Provides enough turbo-thrust for a 250-pound spy or a passel of small children. Maximum travel radius: 3000 miles.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (374,15,'DNTGCGHT','Counterfeit Creation Wallet','image.gif',999.99,'Don''t be caught penniless in Prague without this hot item! Instantly creates replicas of most common currencies! Simply place rocks and water in the wallet, close, open up again, and remove your legal tender!')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (375,16,'WRLD00','Global Navigational System','image.gif',29.99,'No spy should be without one of these premium devices. Determine your exact location with a quick flick of the finger. Calculate destination points by spinning, closing your eyes, and stopping it with your index finger.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (376,15,'CITSME9','Cloaking Device','image.gif',9999.99,'Worried about detection on your covert mission? Confuse mission-threatening forces with this cloaking device. Powerful new features include string-activated pre-programmed phrases such as "Danger! Danger!", "Reach for the sky!", and other anti-enemy expressions. Hyper-reactive karate chop action deters even the most persistent villain.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (377,15,'BME007','Indentity Confusion Device','image.gif',6.99,'Never leave on an undercover mission without our Identity Confusion Device! If a threatening person approaches, deploy the device and point toward the oncoming individual. The subject will fail to recognize you and let you pass unnoticed. Also works well on dogs.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (379,17,'SHADE01','Ultra Violet Attack Defender','image.gif',89.99,'Be safe and suave. A spy wearing this trendy article of clothing is safe from ultraviolet ray-gun attacks. Worn correctly, the Defender deflects rays from ultraviolet weapons back to the instigator. As a bonus, also offers protection against harmful solar ultraviolet rays, equivalent to SPF 50.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (378,17,'SQUKY1','Guard Dog Pacifier','image.gif',14.99,'Pesky guard dogs become a spy''s best friend with the Guard Dog Pacifier. Even the most ferocious dogs suddenly act like cuddly kittens when they see this prop.  Simply hold the device in front of any threatening dogs, shaking it mildly.  For tougher canines, a quick squeeze emits an irresistible squeak that never fails to  place the dog under your control.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (382,20,'CHEW99','Survival Bar','image.gif',6.99,'Survive for up to four days in confinement with this handy item. Disguised as a common eraser, it''s really a high-calorie food bar. Stranded in hostile territory without hope of nourishment? Simply break off a small piece of the eraser and chew vigorously for at least twenty minutes. Developed by the same folks who created freeze-dried ice cream, powdered drink mix, and glow-in-the-dark shoelaces.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (402,20,'C00LCMB1','Telescoping Comb','image.gif',399.99,'Use the Telescoping Comb to track down anyone, anywhere! Deceptively simple, this is no normal comb. Flip the hidden switch and two telescoping lenses project forward creating a surprisingly powerful set of binoculars (50X). Night-vision add-on is available for midnight hour operations.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (384,19,'FF007','Eavesdrop Detector','image.gif',99.99,'Worried that counteragents have placed listening devices in your home or office? No problem! Use our bug-sweeping wiener to check your surroundings for unwanted surveillance devices. Just wave the frankfurter around the room ... when bugs are detected, this "foot-long" beeps! Comes complete with bun, relish, mustard, and headphones for privacy.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (385,16,'LNGWADN','Escape Cord','image.gif',13.99,'Any agent assigned to mountain terrain should carry this ordinary-looking extension cord ... except that it''s really a rappelling rope! Pull quickly on each end to convert the electrical cord into a rope capable of safely supporting up to two agents. Comes in various sizes including Mt McKinley, Everest, and Kilimanjaro. WARNING: To prevent serious injury, be sure to disconnect from wall socket before use.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (386,17,'1MOR4ME','Cocktail Party Pal','image.gif',69.99,'Do your assignments have you flitting from one high society party to the next? Worried about keeping your wits about you as you mingle witih the champagne-and-caviar crowd? No matter how many drinks you''re offered, you can safely operate even the most complicated heavy machinery as long as you use our model 1MOR4ME alcohol-neutralizing coaster. Simply place the beverage glass on the patented circle to eliminate any trace of alcohol in the drink.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (387,20,'SQRTME1','Remote Foliage Feeder','image.gif',9.99,'Even spies need to care for their office plants.  With this handy remote watering device, you can water your flowers as a spy should, from the comfort of your chair.  Water your plants from up to 50 feet away.  Comes with an optional aiming system that can be mounted to the top for improved accuracy.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (388,20,'ICUCLRLY00','Contact Lenses','image.GIF',59.99,'Traditional binoculars and night goggles can be bulky, especially for assignments in confined areas. The problem is solved with these patent-pending contact lenses, which give excellent visibility up to 100 miles. New feature: now with a night vision feature that permits you to see in complete darkness! Contacts now come in a variety of fashionable colors for coordinating with your favorite ensembles.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (389,20,'OPNURMIND','Telekinesis Spoon','image.gif',2.99,'Learn to move things with your mind! Broaden your mental powers using this training device to hone telekinesis skills. Simply look at the device, concentrate, and repeat "There is no spoon" over and over.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (390,19,'ULOST007','Rubber Stamp Beacon','image.gif',129.99,'With the Rubber Stamp Beacon, you''ll never get lost on your missions again. As you proceed through complicated terrain, stamp a stationary object with this device. Once an object has been stamped, the stamp''s patented ink will emit a signal that can be detected up to 153.2 miles away by the receiver embedded in the device''s case. WARNING: Do not expose ink to water.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (391,17,'BSUR2DUC','Bullet Proof Facial Tissue','image.gif',79.99,'Being a spy can be dangerous work. Our patented Bulletproof Facial Tissue gives a spy confidence that any bullets in the vicinity risk-free. Unlike traditional bulletproof devices, these lightweight tissues have amazingly high tensile strength. To protect the upper body, simply place a tissue in your shirt pocket. To protect the lower body, place a tissue in your pants pocket. If you do not have any pockets, be sure to check out our Bulletproof Tape. 100 tissues per box. WARNING: Bullet must not be moving for device to successfully stop penetration.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (393,20,'NOBOOBOO4U','Speed Bandages','image.GIF',3.99,'Even spies make mistakes.  Barbed wire and guard dogs pose a threat of injury for the active spy.  Use our special bandages on cuts and bruises to rapidly heal the injury.  Depending on the severity of the wound, the bandages can take between 10 to 30 minutes to completely heal the injury.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (394,15,'BHONST93','Correction Fluid','image.gif',1.99,'Disguised as typewriter correction fluid, this scientific truth serum forces subjects to correct anything not perfectly true. Simply place a drop of the special correction fluid on the tip of the subject''s nose. Within seconds, the suspect will automatically correct every lie. Effects from Correction Fluid last approximately 30 minutes per drop. WARNING: Discontinue use if skin appears irritated.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (396,19,'BPRECISE00','Dilemma Resolution Device','image.gif',11.99,'Facing a brick wall? Stopped short at a long, sheer cliff wall?  Carry our handy lightweight calculator for just these emergencies. Quickly enter in your dilemma and the calculator spews out the best solutions to the problem.   Manufacturer Warning: Use at own risk. Suggestions may lead to adverse outcomes.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (397,14,'LSRPTR1','Nonexplosive Cigar','image.gif',29.99,'Contrary to popular spy lore, not all cigars owned by spies explode! Best used during mission briefings, our Nonexplosive Cigar is really a cleverly-disguised, top-of-the-line, precision laser pointer. Make your next presentation a hit.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (399,20,'QLT2112','Document Transportation System','image.gif',299.99,'Keep your stolen Top Secret documents in a place they''ll never think to look!  This patent leather briefcase has multiple pockets to keep documents organized.  Top quality craftsmanship to last a lifetime.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (400,15,'THNKDKE1','Hologram Cufflinks','image.gif',799.99,'Just point, and a turn of the wrist will project a hologram of you up to 100 yards away. Sneaking past guards will be child''s play when you''ve sent them on a wild goose chase. Note: Hologram adds ten pounds to your appearance.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (401,14,'TCKLR1','Fake Moustache Translator','image.gif',599.99,'Fake Moustache Translator attaches between nose and mouth to double as a language translator and identity concealer. Sophisticated electronics translate your voice into the desired language. Wriggle your nose to toggle between Spanish, English, French, and Arabic. Excellent on diplomatic missions.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (404,14,'JWLTRANS6','Interpreter Earrings','image.gif',459.99,'The simple elegance of our stylish monosex earrings accents any wardrobe, but their clean lines mask the sophisticated technology within. Twist the lower half to engage a translator function that intercepts spoken words in any language and converts them to the wearer''s native tongue. Warning: do not use in conjunction with our Fake Moustache Translator product, as the resulting feedback loop makes any language sound like Pig Latin.')
INSERT INTO Products (ProductID,CategoryID,ModelNumber,ModelName,ProductImage,UnitCost,Description) VALUES (406,19,'GRTWTCH9','Multi-Purpose Watch','image.gif',399.99,'In the tradition of famous spy movies, the Multi Purpose Watch comes with every convenience! Installed with lighter, TV, camera, schedule-organizing software, MP3 player, water purifier, spotlight, and tire pump. Special feature: Displays current date and time. Kitchen sink add-on will be available in the fall of 2001.')

GO

SET IDENTITY_INSERT Products OFF
GO

SET IDENTITY_INSERT Reviews ON
GO

INSERT INTO Reviews (ReviewID,ProductID,CustomerName,CustomerEmail,Rating,Comments) VALUES (21,404,'Sarah Goodpenny','sg@ibuyspy.com',5,'Really smashing! &nbsp;Don''t know how I''d get by without them!')
INSERT INTO Reviews (ReviewID,ProductID,CustomerName,CustomerEmail,Rating,Comments) VALUES (22,378,'James Bondwell','jb@ibuyspy.com',3,'Well made, but only moderately effective. &nbsp;Ouch!')
GO

SET IDENTITY_INSERT Reviews OFF
GO

INSERT INTO QuantityDiscounts(ProductId, QuantityDiscount, QuantityDiscountLevel) SELECT ProductID, 0.1, 5 FROM Products
GO

declare @count int
set @count = 0
while (@count < 5000)
begin
	declare @MaxId int
	select @MaxId=Max(ProductId) from Products
	set @MaxId = @MaxId + 1
	Insert Into QuantityDiscounts(ProductId, QuantityDiscount, QuantityDiscountLevel) VALUES(@MaxId, 0.1,5)
	
	set @Count = @Count + 1
end
GO

SET NOCOUNT ON

DECLARE @prodid int, @modelNumber nvarchar(50)



DECLARE products_cursor CURSOR FOR 
SELECT productid, modelNumber
FROM products


OPEN products_cursor

FETCH NEXT FROM products_cursor 
INTO @prodid, @modelNumber

WHILE @@FETCH_STATUS = 0
BEGIN

   UPDATE Products
   set ProductImage = @modelNumber+'.gif'
   WHERE Productid = @prodid  



   -- Get the next author.
   FETCH NEXT FROM products_cursor
   INTO @prodid, @modelNumber
END

CLOSE products_cursor
DEALLOCATE products_cursor
GO

GO

-- ===============================================
-- Populate Customers in IBUYSPY Store DATABASE
-- 
-- ===============================================

USE [Store]
GO

Delete From ShoppingCart
Go

Delete FROM OrderDetails
GO

Delete FROM Orders
GO
Delete FROM Customers
GO


SET IDENTITY_INSERT Customers ON
GO

INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (1,'James001','James001@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (2,'James002','James002@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (3,'James003','James003@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (4,'James004','James004@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (5,'James005','James005@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (6,'James006','James006@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (7,'James007','James007@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (8,'James008','James008@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (9,'James009','James009@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (10,'James010','James010@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (11,'James011','James011@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (12,'James012','James012@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (13,'James013','James013@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (14,'James014','James014@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (15,'James015','James015@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (16,'James016','James016@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (17,'James017','James017@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (18,'James018','James018@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (19,'James019','James019@bond.com','pwd')
INSERT INTO Customers (CustomerID,FullName,EmailAddress,Password) VALUES (20,'James Bondwell','jb@ibuyspy.com','IBS_007')
GO

SET IDENTITY_INSERT Customers OFF
GO

delete from QuantityDiscounts
GO

INSERT INTO QuantityDiscounts(ProductId, QuantityDiscount, QuantityDiscountLevel) SELECT ProductID, 0.1, 5 FROM Products
GO

declare @count int
set @count = 0
while (@count < 5000)
begin
	declare @MaxId int
	select @MaxId=Max(ProductId) from Products
	set @MaxId = @MaxId + 1
	Insert Into QuantityDiscounts(ProductId, QuantityDiscount, QuantityDiscountLevel) VALUES(@MaxId, 0.1,5)
	
	set @Count = @Count + 1
end
GO

