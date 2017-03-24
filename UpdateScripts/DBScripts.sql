--TABLES

USE [EntiTrees]
GO

/****** Object:  Table [dbo].[Category]    Script Date: 12.5.2016 г. 18:12:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[SystemName] [nvarchar](50) NOT NULL,
	[Src] [nvarchar](50) NOT NULL,
	[ImgSrc] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[Customer]    Script Date: 12.5.2016 г. 18:12:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[ShoppingItem]    Script Date: 12.5.2016 г. 18:13:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ShoppingItem](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Price] [float] NOT NULL,
	[Discount] [int] NULL,
	[LastModified] [datetime] NOT NULL,
	[ImageSrc] [nvarchar](150) NULL,
	[Quantity] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_ShoppingItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[ShoppingItem] ADD  CONSTRAINT [DF_ShoppingItem_LastModified]  DEFAULT (getdate()) FOR [LastModified]
GO

ALTER TABLE [dbo].[ShoppingItem] ADD  CONSTRAINT [DF_ShoppingItem_Quantity]  DEFAULT ((1)) FOR [Quantity]
GO

ALTER TABLE [dbo].[ShoppingItem] ADD  CONSTRAINT [DF_ShoppingItem_IsVisible]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[ShoppingItem]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingItem_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO

ALTER TABLE [dbo].[ShoppingItem] CHECK CONSTRAINT [FK_ShoppingItem_Category]
GO

ALTER TABLE [dbo].[ShoppingItem]  WITH CHECK ADD  CONSTRAINT [CK_ShoppingItem] CHECK  (([Quantity]>(-1)))
GO

ALTER TABLE [dbo].[ShoppingItem] CHECK CONSTRAINT [CK_ShoppingItem]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Relative path to the main image src of the item' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ShoppingItem', @level2type=N'COLUMN',@level2name=N'ImageSrc'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Default quantity of this item in the shop' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ShoppingItem', @level2type=N'COLUMN',@level2name=N'Quantity'
GO


USE [EntiTrees]
GO

/****** Object:  Table [dbo].[ShoppingCart]    Script Date: 23.5.2016 г. 17:19:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ShoppingCart](
	[ShoppingCartId] [int] NOT NULL,
	[ShoppingItemId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[SinglePrice] [float] NULL,
 CONSTRAINT [PK_ShoppingCart] PRIMARY KEY CLUSTERED 
(
	[ShoppingCartId] ASC,
	[ShoppingItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The price for the single item.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ShoppingCart', @level2type=N'COLUMN',@level2name=N'SinglePrice'
GO


/****** Object:  Table [dbo].[Order]    Script Date: 25.5.2016 г. 11:47:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShoppingCartId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Message] [nvarchar](500) NULL,
	[IsCompleted] [bit] NOT NULL,
	[Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_IsCompleted]  DEFAULT ((0)) FOR [IsCompleted]
GO

ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_Date]  DEFAULT (getdate()) FOR [Date]
GO



---------------------------------------------------STORED PROCEDURES

/****** Object:  StoredProcedure [dbo].[DeleteShopItem]    Script Date: 12.5.2016 г. 18:15:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteShopItem]
	@ID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   UPDATE [dbo].[ShoppingItem]
   SET [IsDeleted] = 1
   WHERE Id = @ID
END

GO




USE [EntiTrees]
GO
/****** Object:  StoredProcedure [dbo].[InsertNewOrder]    Script Date: 23.5.2016 г. 17:18:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertNewOrder]
	@InXML xml
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @XmlDataDummy XML = @InXML

	BEGIN TRY

		DECLARE @CustomerName nvarchar(150) = @XmlDataDummy.value('(/Order/customer/name/text())[1]', 'nvarchar(150)')
        DECLARE @CustomerEmail nvarchar(50) = @XmlDataDummy.value('(/Order/customer/email/text())[1]', 'nvarchar(50)')
        DECLARE @CustomerPhone nvarchar(50) = @XmlDataDummy.value('(/Order/customer/phone/text())[1]', 'nvarchar(50)')
        DECLARE @CustomerAddress nvarchar(200) = @XmlDataDummy.value('(/Order/customer/address/text())[1]', 'nvarchar(200)')
		DECLARE @Message nvarchar(500) = @XmlDataDummy.value('(/Order/customer/message/text())[1]', 'nvarchar(500)')
		DECLARE @ShoppingCartId int = ISNULL((SELECT TOP 1 ShoppingCartId from ShoppingCart order by ShoppingCartId desc), 0)
		SET @ShoppingCartId = @ShoppingCartId + 1
		DECLARE @NewCustomerId INT

		BEGIN TRANSACTION
		
		--Insert the new customer
		INSERT INTO [dbo].[Customer]
			   ([Name]
			   ,[Email]
			   ,[Phone]
			   ,[Address])
		 VALUES
			   (@CustomerName
			   ,@CustomerEmail
			   ,@CustomerPhone
			   ,@CustomerAddress)

		SELECT @NewCustomerId = Scope_Identity();
						
		--decrease quantity values
		DECLARE @itemId int
		DECLARE @itemPrice float
		DECLARE @itemDiscount int
		DECLARE @quantity int
		DECLARE crsItems cursor static forward_only read_only for 
		SELECT t.c.value('(item/id/text())[1]','int') AS id, 
			   t.c.value('(item/price/text())[1]','float') AS price,
			   t.c.value('(item/discount/text())[1]','int') AS discount, 
               t.c.value('(quantity/text())[1]','nvarchar(200)') AS [quantity]		          
	    FROM @InXML.nodes('Order/shoppingCart/OrderItem')t(c)

		OPEN crsItems;
		FETCH NEXT FROM crsItems INTO @itemId, @itemPrice, @itemDiscount, @quantity;
		WHILE 0 = @@fetch_status
		BEGIN
			INSERT INTO ShoppingCart(ShoppingCartId, ShoppingItemId, Quantity, SinglePrice)
			VALUES (@ShoppingCartId, @itemId, @quantity, @itemPrice - @itemPrice * @itemDiscount / 100)

			UPDATE ShoppingItem
			SET Quantity = Quantity - @quantity
			WHERE Id = @itemId
		FETCH NEXT FROM crsItems INTO @itemId, @itemPrice, @itemDiscount, @quantity;
		END 
		CLOSE crsItems;
		DEALLOCATE crsItems;

		INSERT INTO [dbo].[Order]([ShoppingCartId],[CustomerId],[Message])
		VALUES(@ShoppingCartId, @NewCustomerId, @Message)

		COMMIT TRANSACTION

		SELECT 'Order inserted successfully' as ResultMessage,
			'201' as Result

	END TRY
    BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION

		SELECT 'There was an error while inserting order' as ResultMessage,
			'500' as Result
	END CATCH
END


/****** Object:  StoredProcedure [dbo].[InsertNewShopItem]    Script Date: 12.5.2016 г. 18:15:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[InsertNewShopItem]
	@Title nvarchar(200),
	@Description nvarchar(max),
	@Price float,
	@Discount int = 0,
	@ImageSrc nvarchar(150),
	@Quantity int,
	@CategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   INSERT INTO [dbo].[ShoppingItem]
           ([Title]
           ,[Description]
           ,[Price]
           ,[Discount]
           ,[LastModified]
           ,[ImageSrc]
           ,[Quantity]
		   ,[CategoryId])
     VALUES
           (@Title
           ,@Description
           ,@Price
           ,@Discount
           ,getdate()
           ,@ImageSrc
           ,@Quantity
		   ,@CategoryId)
END

GO


/****** Object:  StoredProcedure [dbo].[SelectCategories]    Script Date: 12.5.2016 г. 18:15:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectCategories] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT c.[Id]
      ,c.[Name]
      ,c.[Description]
      ,c.[SystemName]
      ,c.[Src]
      ,c.[ImgSrc]
	  ,count(si.Id) AS ItemsCount
	FROM [EntiTrees].[dbo].[Category] AS c
	LEFT JOIN [EntiTrees].[dbo].[ShoppingItem] AS si ON c.Id = si.CategoryId AND si.Quantity > 0 AND si.IsDeleted = 0
	GROUP BY c.Id
	  ,c.[Name]
      ,c.[Description]
      ,c.[SystemName]
      ,c.[Src]
      ,c.[ImgSrc]
	ORDER BY c.Id
END

GO



/****** Object:  StoredProcedure [dbo].[SelectShoppingItems]    Script Date: 12.5.2016 г. 18:16:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectShoppingItems]
	@CategoryID int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [Id]
      ,[Title]
      ,[Description]
      ,[Price]
      ,[Discount]
      ,[LastModified]
      ,[ImageSrc]
      ,[Quantity]
      ,[CategoryId]
  FROM [EntiTrees].[dbo].[ShoppingItem]
  WHERE @CategoryID is null or @CategoryID = [CategoryId]
	 AND IsDeleted = 0
END

GO


/****** Object:  StoredProcedure [dbo].[UpdateShopItem]    Script Date: 12.5.2016 г. 18:16:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateShopItem]
	@ID int,
	@Title nvarchar(200),
	@Description nvarchar(max),
	@Price float,
	@Discount int = 0,
	@ImageSrc nvarchar(150),
	@Quantity int,
	@CategoryId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE [dbo].[ShoppingItem]
	SET [Title] = @Title
      ,[Description] = @Description
      ,[Price] = @Price
      ,[Discount] = @Discount
      ,[LastModified] = GETDATE()
      ,[ImageSrc] = @ImageSrc
      ,[Quantity] = @Quantity
	WHERE Id = @ID
END

GO


/****** Object:  StoredProcedure [dbo].[SelectOrders]    Script Date: 25.5.2016 г. 11:53:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectOrders]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT o.[Id]
      ,o.[ShoppingCartId]
      ,o.[CustomerId]
      ,o.[Message]
      ,o.[IsCompleted]
	  ,o.[Date]
	  ,SUM(sc.Quantity) AS Quantity
	  ,SUM(sc.SinglePrice * sc.Quantity) AS TotalPrice
	FROM [EntiTrees].[dbo].[Order] AS o
	INNER JOIN [EntiTrees].[dbo].[ShoppingCart] AS sc ON o.ShoppingCartId = sc.ShoppingCartId
	GROUP BY  o.[Id]
      ,o.[ShoppingCartId]
      ,o.[CustomerId]
      ,o.[Message]
      ,o.[IsCompleted]
	  ,o.[Date]
	ORDER BY [IsCompleted] ASC, [Date] ASC
END

GO




/****** Object:  StoredProcedure [dbo].[SelectOrderByID]    Script Date: 25.5.2016 г. 11:53:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectOrderByID]
	@OrderID INT
AS
BEGIN
	
	SELECT o.[Id] as OrderId
      ,o.[ShoppingCartId]
      ,o.[CustomerId]
      ,o.[Message]
      ,o.[IsCompleted]
	  ,o.[Date]
	  ,c.Name
	  ,c.Phone
	  ,c.Email
	  ,c.[Address]
  FROM [dbo].[Order] AS o
  INNER JOIN [dbo].[Customer] AS c on o.CustomerId = c.Id
  WHERE o.Id = @OrderID

END

GO



/****** Object:  StoredProcedure [dbo].[SelectOrderItemsByOrderID]    Script Date: 26.5.2016 г. 12:34:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SelectOrderItemsByOrderID] 
	@OrderID INT
AS
BEGIN
	SELECT sc.[ShoppingCartId]
      ,sc.[ShoppingItemId]
      ,sc.[Quantity]
      ,sc.[SinglePrice]
	  ,si.Title
	  ,si.ImageSrc
	  ,si.Price
	  ,si.Discount
	  ,c.Name
  FROM [EntiTrees].[dbo].[ShoppingCart] as sc
  INNER JOIN [dbo].[Order] AS o ON o.ShoppingCartId = sc.ShoppingCartId
  INNER JOIN [dbo].[ShoppingItem] AS si ON si.Id = sc.ShoppingItemId
  INNER JOIN [dbo].[Category] AS c on c.Id = si.CategoryId
  WHERE o.Id = @OrderID
END

GO


/****** Object:  StoredProcedure [dbo].[UpdateOrder]    Script Date: 26.5.2016 г. 14:46:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateOrder]
	@OrderID INT,
	@IsCompleted BIT
AS
BEGIN

UPDATE [dbo].[Order]
   SET [IsCompleted] = @IsCompleted     
 WHERE Id = @OrderID

END

GO

------------------INSERTS -----------------------------------------

INSERT INTO [dbo].[Category]
           ([Name]
           ,[Description]
           ,[SystemName]
           ,[Src]
           ,[ImgSrc])
     VALUES
           ('Растения'
           ,'Продажба на различни видове растения бонсаи и ...'
           ,' plants'
           ,' shop/plants'
           ,' img/gallery/10.jpg' )
INSERT INTO [dbo].[Category]
           ([Name]
           ,[Description]
           ,[SystemName]
           ,[Src]
           ,[ImgSrc])
     VALUES
           ('Почви'
           ,'Продажба на различни видове почви, подходящи за отглеждане на бонсаи'
           ,' soil'
           ,' shop/soil'
           ,' img/gallery/1.jpg' )
INSERT INTO [dbo].[Category]
           ([Name]
           ,[Description]
           ,[SystemName]
           ,[Src]
           ,[ImgSrc])
     VALUES
           ('Саксии'
           ,'Продажба на ръчно правени саксии за бонсаи, в различни видове и размери'
           ,' pots'
           ,' shop/pots'
           ,' img/gallery/5.jpg' )
INSERT INTO [dbo].[Category]
           ([Name]
           ,[Description]
           ,[SystemName]
           ,[Src]
           ,[ImgSrc])
     VALUES
           ('Аксесоари'
           ,'Всякакви аксесоари, необходими за грижите за вашите растения'
           ,' accessories'
           ,' shop/accessories'
           ,' img/gallery/15.jpg' )
INSERT INTO [dbo].[Category]
           ([Name]
           ,[Description]
           ,[SystemName]
           ,[Src]
           ,[ImgSrc])
     VALUES
           ('Торове'
           ,'Различни видове торове, подходящи за различните бонсаи'
           ,' fertilization'
           ,' shop/fertilization'
           ,' img/gallery/5.jpg' )
GO


------------------------------------------UPDATE DB 16.06.2016-------------------------------------------

EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'DateCompleted'

GO

EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'Date'

GO

ALTER TABLE [dbo].[Order] DROP CONSTRAINT [DF_Order_Date]
GO

ALTER TABLE [dbo].[Order] DROP CONSTRAINT [DF_Order_IsCompleted]
GO

/****** Object:  Table [dbo].[Order]    Script Date: 16.6.2016 г. 15:12:07 ******/
DROP TABLE [dbo].[Order]
GO

/****** Object:  Table [dbo].[Order]    Script Date: 16.6.2016 г. 15:12:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Order](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShoppingCartId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Message] [nvarchar](500) NULL,
	[IsCompleted] [bit] NOT NULL,
	[Date] [datetime] NOT NULL,
	[DateCompleted] [datetime] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_IsCompleted]  DEFAULT ((0)) FOR [IsCompleted]
GO

ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_Date]  DEFAULT (getdate()) FOR [Date]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The datetime when the order is inserted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'Date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Datetime when the order is completed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Order', @level2type=N'COLUMN',@level2name=N'DateCompleted'
GO




-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[UpdateOrder]
	@OrderID INT,
	@IsCompleted BIT
AS
BEGIN

UPDATE [dbo].[Order]
   SET [IsCompleted] = @IsCompleted,
	   [DateCompleted] = CASE WHEN @IsCompleted = '1' THEN GETDATE() ELSE NULL END
 WHERE Id = @OrderID

END
GO


-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SelectOrders]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT o.[Id]
      ,o.[ShoppingCartId]
      ,o.[CustomerId]
      ,o.[Message]
      ,o.[IsCompleted]
	  ,o.[Date]
	  ,o.[DateCompleted]
	  ,SUM(sc.Quantity) AS Quantity
	  ,SUM(sc.SinglePrice * sc.Quantity) AS TotalPrice
	FROM [EntiTrees].[dbo].[Order] AS o
	INNER JOIN [EntiTrees].[dbo].[ShoppingCart] AS sc ON o.ShoppingCartId = sc.ShoppingCartId
	GROUP BY  o.[Id]
      ,o.[ShoppingCartId]
      ,o.[CustomerId]
      ,o.[Message]
      ,o.[IsCompleted]
	  ,o.[Date]
	  ,o.[DateCompleted]
	ORDER BY [IsCompleted] ASC, [Date] ASC
END
GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SelectOrderByID]
	@OrderID INT
AS
BEGIN
	
	SELECT o.[Id] as OrderId
      ,o.[ShoppingCartId]
      ,o.[CustomerId]
      ,o.[Message]
      ,o.[IsCompleted]
	  ,o.[Date]
	  ,o.[DateCompleted]
	  ,c.Name
	  ,c.Phone
	  ,c.Email
	  ,c.[Address]
  FROM [dbo].[Order] AS o
  INNER JOIN [dbo].[Customer] AS c on o.CustomerId = c.Id
  WHERE o.Id = @OrderID
END
GO
------------------------------------------UPDATE DB 20.06.2016-------------------------------------------

-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[InsertNewOrder]
	@InXML xml
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @XmlDataDummy XML = @InXML

	BEGIN TRY

		DECLARE @CustomerName nvarchar(150) = @XmlDataDummy.value('(/Order/customer/name/text())[1]', 'nvarchar(150)')
        DECLARE @CustomerEmail nvarchar(50) = @XmlDataDummy.value('(/Order/customer/email/text())[1]', 'nvarchar(50)')
        DECLARE @CustomerPhone nvarchar(50) = @XmlDataDummy.value('(/Order/customer/phone/text())[1]', 'nvarchar(50)')
        DECLARE @CustomerAddress nvarchar(200) = @XmlDataDummy.value('(/Order/customer/address/text())[1]', 'nvarchar(200)')
		DECLARE @Message nvarchar(500) = @XmlDataDummy.value('(/Order/customer/message/text())[1]', 'nvarchar(500)')
		DECLARE @ShoppingCartId int = ISNULL((SELECT TOP 1 ShoppingCartId from ShoppingCart order by ShoppingCartId desc), 0)
		SET @ShoppingCartId = @ShoppingCartId + 1
		DECLARE @NewCustomerId INT

		BEGIN TRANSACTION
		
		--Insert the new customer
		INSERT INTO [dbo].[Customer]
			   ([Name]
			   ,[Email]
			   ,[Phone]
			   ,[Address])
		 VALUES
			   (@CustomerName
			   ,@CustomerEmail
			   ,@CustomerPhone
			   ,@CustomerAddress)

		SELECT @NewCustomerId = Scope_Identity();
						
		--decrease quantity values
		DECLARE @itemId int
		DECLARE @itemPrice float
		DECLARE @itemDiscount int
		DECLARE @quantity int
		DECLARE crsItems cursor static forward_only read_only for 
		SELECT t.c.value('(item/id/text())[1]','int') AS id, 
			   t.c.value('(item/price/text())[1]','float') AS price,
			   t.c.value('(item/discount/text())[1]','int') AS discount, 
               t.c.value('(quantity/text())[1]','nvarchar(200)') AS [quantity]		          
	    FROM @InXML.nodes('Order/shoppingCart/OrderItem')t(c)

		OPEN crsItems;
		FETCH NEXT FROM crsItems INTO @itemId, @itemPrice, @itemDiscount, @quantity;
		WHILE 0 = @@fetch_status
		BEGIN
			INSERT INTO ShoppingCart(ShoppingCartId, ShoppingItemId, Quantity, SinglePrice)
			VALUES (@ShoppingCartId, @itemId, @quantity, @itemPrice - @itemPrice * @itemDiscount / 100)

			UPDATE ShoppingItem
			SET Quantity = Quantity - @quantity
			WHERE Id = @itemId
		FETCH NEXT FROM crsItems INTO @itemId, @itemPrice, @itemDiscount, @quantity;
		END 
		CLOSE crsItems;
		DEALLOCATE crsItems;

		INSERT INTO [dbo].[Order]([ShoppingCartId],[CustomerId],[Message])
		VALUES(@ShoppingCartId, @NewCustomerId, @Message)

		COMMIT TRANSACTION

		SELECT 'Order inserted successfully' as ResultMessage,
			'201' as Result,
			Scope_Identity() as OrderID

	END TRY
    BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION

		SELECT 'There was an error while inserting order' as ResultMessage,
			'500' as Result,
			'0' as OrderID
	END CATCH
END

GO



------------------------------------------UPDATE DB 18.07.2016-------------------------------------------

USE [EntiTrees]
GO
/****** Object:  StoredProcedure [dbo].[SelectShoppingItems]    Script Date: 18.7.2016 г. 15:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lilia Hristova
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SelectShoppingItems]
	@CategoryID int = NULL,
	@ItemID int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [Id]
      ,[Title]
      ,[Description]
      ,[Price]
      ,[Discount]
      ,[LastModified]
      ,[ImageSrc]
      ,[Quantity]
      ,[CategoryId]
  FROM [EntiTrees].[dbo].[ShoppingItem]
  WHERE ( @CategoryID is null or @CategoryID = [CategoryId] ) 
	 AND (@ItemID is null or @ItemID = [Id])
	 AND IsDeleted = 0
END

GO


-- =============================================
-- Author:		Lilia Hristova
-- Create date: 23 Mar 2017
-- Description:	Selects all customer from the DB
-- =============================================
CREATE PROCEDURE SelectCustomers
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT c.[Id]
      ,[Name]
      ,[Email]
      ,[Phone]
      ,[Address]
	  ,COUNT(o.Id) OrdersCount
    FROM [EntiTrees].[dbo].[Customer] as c
	INNER JOIN [EntiTrees].[dbo].[Order] as o ON o.CustomerId = c.Id
	GROUP BY c.Id, Name, Email, Phone, Address
	ORDER BY c.Id DESC
END
GO


/****** Object:  Table [dbo].[Contacts]    Script Date: 3/23/17 16:10:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contacts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[Phone] [nvarchar](20) NULL,
	[Message] [nvarchar](500) NOT NULL,
	[IsCompleted] [bit] NULL CONSTRAINT [DF_Contacts_IsCompleted]  DEFAULT ((0)),
	[Date] [datetime] NOT NULL CONSTRAINT [DF_Contacts_Date]  DEFAULT (getdate()),
	[DateCompleted] [datetime] NULL,
	[Answer] [nvarchar](500) NULL
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date when the contact is inserted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Contacts', @level2type=N'COLUMN',@level2name=N'Date'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The date when we send back the response.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Contacts', @level2type=N'COLUMN',@level2name=N'DateCompleted'
GO

GO

-- =============================================
-- Author:		Lilia Hristova
-- Create date: 23 Mar 2017
-- Description:	Insert new contact message in the DB
-- =============================================
CREATE PROCEDURE [dbo].[InsertContact] 
	-- Add the parameters for the stored procedure here
	@Name nvarchar(100),
	@Email nvarchar(100),
	@Phone nvarchar(20),
	@Message nvarchar(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO [dbo].[Contacts]
           ([Name]
           ,[Email]
           ,[Phone]
           ,[Message])
     VALUES
           (@Name
           ,@Email
           ,@Phone
           ,@Message)
END

GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lilia Hristova
-- Create date: 24 Mar 2017
-- Description:	Selects all contacts
-- =============================================
CREATE PROCEDURE SelectContacts 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT [Id]
      ,[Name]
      ,[Email]
      ,[Phone]
      ,[Message]
      ,[IsCompleted]
      ,[Date]
      ,[DateCompleted]
	  ,[Answer]
    FROM [EntiTrees].[dbo].[Contacts]
    ORDER BY [IsCompleted] ASC, [Date] ASC
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lilia Hristova
-- Create date: 24 Mar 2017
-- Description:	Updates the contact to completed
-- =============================================
CREATE PROCEDURE UpdateContact
	@ContactId INT,
	@IsCompleted BIT,
	@Answer NVARCHAR(500) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE [dbo].[Contacts]
   SET [IsCompleted] = @IsCompleted,
	   [DateCompleted] = CASE WHEN @IsCompleted = '1' THEN GETDATE() ELSE NULL END,
	   [Answer] = @Answer
 WHERE Id = @ContactId
END
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lilia Hristova
-- Create date: 24 Mar 2017
-- Description:	Selects the notifications for the home page of the admin section
-- =============================================
CREATE PROCEDURE SelectAdminHomeNotifications 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
	(SELECT COUNT(Id) FROM [dbo].[ShoppingItem] WHERE IsDeleted = 0 AND Quantity > 0) AS 'ActiveItems',
	(SELECT COUNT(Id) FROM [dbo].[ShoppingItem] WHERE IsDeleted = 0) AS 'AllItems',
	(SELECT COUNT(Id) FROM [dbo].[Order] WHERE IsCompleted = 0) AS 'OpenOrders',
	(SELECT COUNT(Id) FROM [dbo].[Order]) AS 'AllOrders',
	(SELECT COUNT(Email) FROM [dbo].[Customer]) AS 'CustomersCount',
	(SELECT COUNT([Id]) FROM [dbo].[Contacts] WHERE IsCompleted = 0) AS 'OpenContacts',
	(SELECT COUNT([Id]) FROM [dbo].[Contacts]) AS 'AllContacts'

 
END
GO
