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

