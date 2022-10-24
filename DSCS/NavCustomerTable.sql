SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Deufol_Central_Company$Customer](
	[timestamp] [timestamp] NOT NULL,
	[No_] [nvarchar](20) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Search Name] [nvarchar](50) NOT NULL,
	[Name 2] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[Address 2] [nvarchar](50) NOT NULL,
	[City] [nvarchar](30) NOT NULL,
	[Contact] [nvarchar](50) NOT NULL,
	[Phone No_] [nvarchar](30) NOT NULL,
	[Telex No_] [nvarchar](20) NOT NULL,
	[Document Sending Profile] [nvarchar](20) NOT NULL,
	[Our Account No_] [nvarchar](20) NOT NULL,
	[Territory Code] [nvarchar](10) NOT NULL,
	[Global Dimension 1 Code] [nvarchar](20) NOT NULL,
	[Global Dimension 2 Code] [nvarchar](20) NOT NULL,
	[Chain Name] [nvarchar](10) NOT NULL,
	[Budgeted Amount] [decimal](38, 20) NOT NULL,
	[Credit Limit (LCY)] [decimal](38, 20) NOT NULL,
	[Customer Posting Group] [nvarchar](20) NOT NULL,
	[Currency Code] [nvarchar](10) NOT NULL,
	[Customer Price Group] [nvarchar](10) NOT NULL,
	[Language Code] [nvarchar](10) NOT NULL,
	[Statistics Group] [int] NOT NULL,
	[Payment Terms Code] [nvarchar](10) NOT NULL,
	[Fin_ Charge Terms Code] [nvarchar](10) NOT NULL,
	[Salesperson Code] [nvarchar](20) NOT NULL,
	[Shipment Method Code] [nvarchar](10) NOT NULL,
	[Shipping Agent Code] [nvarchar](10) NOT NULL,
	[Place of Export] [nvarchar](20) NOT NULL,
	[Invoice Disc_ Code] [nvarchar](20) NOT NULL,
	[Customer Disc_ Group] [nvarchar](20) NOT NULL,
	[Country_Region Code] [nvarchar](10) NOT NULL,
	[Collection Method] [nvarchar](20) NOT NULL,
	[Amount] [decimal](38, 20) NOT NULL,
	[Blocked] [int] NOT NULL,
	[Invoice Copies] [int] NOT NULL,
	[Last Statement No_] [int] NOT NULL,
	[Print Statements] [tinyint] NOT NULL,
	[Bill-to Customer No_] [nvarchar](20) NOT NULL,
	[Priority] [int] NOT NULL,
	[Payment Method Code] [nvarchar](10) NOT NULL,
	[Last Date Modified] [datetime] NOT NULL,
	[Application Method] [int] NOT NULL,
	[Prices Including VAT] [tinyint] NOT NULL,
	[Location Code] [nvarchar](10) NOT NULL,
	[Fax No_] [nvarchar](30) NOT NULL,
	[Telex Answer Back] [nvarchar](20) NOT NULL,
	[VAT Registration No_] [nvarchar](20) NOT NULL,
	[Combine Shipments] [tinyint] NOT NULL,
	[Gen_ Bus_ Posting Group] [nvarchar](20) NOT NULL,
	[Picture] [image] NULL,
	[GLN] [nvarchar](13) NOT NULL,
	[Post Code] [nvarchar](20) NOT NULL,
	[County] [nvarchar](30) NOT NULL,
	[E-Mail] [nvarchar](80) NOT NULL,
	[Home Page] [nvarchar](80) NOT NULL,
	[Reminder Terms Code] [nvarchar](10) NOT NULL,
	[No_ Series] [nvarchar](20) NOT NULL,
	[Tax Area Code] [nvarchar](20) NOT NULL,
	[Tax Liable] [tinyint] NOT NULL,
	[VAT Bus_ Posting Group] [nvarchar](20) NOT NULL,
	[Reserve] [int] NOT NULL,
	[Block Payment Tolerance] [tinyint] NOT NULL,
	[IC Partner Code] [nvarchar](20) NOT NULL,
	[Prepayment _] [decimal](38, 20) NOT NULL,
	[Partner Type] [int] NOT NULL,
	[Preferred Bank Account Code] [nvarchar](20) NOT NULL,
	[Cash Flow Payment Terms Code] [nvarchar](10) NOT NULL,
	[Primary Contact No_] [nvarchar](20) NOT NULL,
	[Responsibility Center] [nvarchar](10) NOT NULL,
	[Shipping Advice] [int] NOT NULL,
	[Shipping Time] [varchar](32) NOT NULL,
	[Shipping Agent Service Code] [nvarchar](10) NOT NULL,
	[Service Zone Code] [nvarchar](10) NOT NULL,
	[Allow Line Disc_] [tinyint] NOT NULL,
	[Base Calendar Code] [nvarchar](10) NOT NULL,
	[Copy Sell-to Addr_ to Qte From] [int] NOT NULL,
	[Customer Template Code] [nvarchar](10) NOT NULL,
	[VV Invoicing] [tinyint] NOT NULL,
	[SAP Customer No_] [nvarchar](10) NOT NULL,
	[Surcharge _] [decimal](38, 20) NOT NULL,
	[Insurance _] [decimal](38, 20) NOT NULL,
	[Discount _] [decimal](38, 20) NOT NULL,
	[Subject Type] [int] NOT NULL,
	[Responsible Person Code] [nvarchar](10) NOT NULL,
	[Registration No_] [nvarchar](20) NOT NULL,
	[Freeholder] [tinyint] NOT NULL,
	[Integration Status] [int] NOT NULL,
	[DFM Additional Charge] [decimal](38, 20) NOT NULL,
	[VV Customer No_] [nvarchar](30) NOT NULL,
	[Blocked_Editing] [tinyint] NOT NULL,
	[Privacy Blocked] [tinyint] NOT NULL,
	[Customer Ledger Entry Exists] [tinyint] NOT NULL,
	[Default Invoice-to Code] [nvarchar](10) NOT NULL,
	[Last Modified Date Time] [datetime] NOT NULL,
	[Image] [uniqueidentifier] NOT NULL,
	[Disable Search by Name] [tinyint] NOT NULL,
	[Contact Type] [int] NOT NULL,
	[Validate EU Vat Reg_ No_] [tinyint] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[Currency Id] [uniqueidentifier] NOT NULL,
	[Payment Terms Id] [uniqueidentifier] NOT NULL,
	[Shipment Method Id] [uniqueidentifier] NOT NULL,
	[Payment Method Id] [uniqueidentifier] NOT NULL,
	[Tax Area ID] [uniqueidentifier] NOT NULL,
	[Contact ID] [uniqueidentifier] NOT NULL,
	[Contact Graph Id] [nvarchar](250) NOT NULL,
	[Blocked_Editing Previous State] [int] NOT NULL,
 CONSTRAINT [Deufol_Central_Company$Customer$0] PRIMARY KEY CLUSTERED 
(
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$1] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Search Name] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$10] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Post Code] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$11] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Phone No_] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$12] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Contact] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$2] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Customer Posting Group] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$3] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Currency Code] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$4] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Country_Region Code] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$5] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Gen_ Bus_ Posting Group] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$6] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Name] ASC,
	[Address] ASC,
	[City] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$7] ON [dbo].[Deufol_Central_Company$Customer]
(
	[VAT Registration No_] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$8] ON [dbo].[Deufol_Central_Company$Customer]
(
	[Name] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [$9] ON [dbo].[Deufol_Central_Company$Customer]
(
	[City] ASC,
	[No_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
