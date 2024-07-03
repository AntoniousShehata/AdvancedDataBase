-- --------------------------------------------------------

--
-- Structure for view `bestselling`
--
DROP TABLE IF EXISTS `bestselling`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `bestselling`  AS SELECT `ordersdetail`.`ProductID` AS `ProductID`, `category`.`Name` AS `Category`, `product`.`Description` AS `Product`, sum(`ordersdetail`.`Quantity`) AS `TotalAmount`, sum(`ordersdetail`.`Price`) AS `TotalPrice`, `supplier`.`SupplierID` AS `SupplierID`, `supplier`.`Name` AS `Supplier`, `supplier`.`Notes` AS `SupplierType` FROM (((((`ordersdetail` join `product` on(`ordersdetail`.`ProductID` = `product`.`ProductID`)) join `purchasedetail` on(`product`.`ProductID` = `purchasedetail`.`ProductID`)) join `purchase` on(`purchasedetail`.`PurchaseID` = `purchase`.`PurchaseID`)) join `supplier` on(`purchase`.`SupplierID` = `supplier`.`SupplierID`)) join `category` on(`product`.`CategoryID` = `category`.`CategoryID`)) GROUP BY `ordersdetail`.`ProductID`, `product`.`Description`, `supplier`.`SupplierID`, `supplier`.`Name`, `category`.`Name`, `supplier`.`Notes` ORDER BY sum(`ordersdetail`.`Quantity`) DESC LIMIT 0, 10 ;

-- --------------------------------------------------------

--
-- Structure for view `customerpurchases`
--
DROP TABLE IF EXISTS `customerpurchases`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `customerpurchases`  AS SELECT `customer`.`CustomerID` AS `CustomerID`, `customer`.`Name` AS `Customer`, sum(`ordersdetail`.`Price`) AS `TotalPurchase` FROM ((`customer` join `orders` on(`customer`.`CustomerID` = `orders`.`CustomerID`)) join `ordersdetail` on(`orders`.`OrdersID` = `ordersdetail`.`OrdersID`)) WHERE `orders`.`Status` = 1 AND `ordersdetail`.`Status` = 1 GROUP BY `customer`.`CustomerID`, `customer`.`Name`, `orders`.`Status`, `ordersdetail`.`Status` ORDER BY sum(`ordersdetail`.`Price`) DESC LIMIT 0, 100 ;

-- --------------------------------------------------------

--
-- Structure for view `fashionproducts`
--
DROP TABLE IF EXISTS `fashionproducts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `fashionproducts`  AS SELECT `product`.`ProductID` AS `ProductID`, `product`.`Description` AS `Product`, `product`.`Comments` AS `Comments`, date_format(`orders`.`Date`,'%M') AS `OrderMonth`, count(0) AS `TotalOrders`, sum(`ordersdetail`.`Quantity`) AS `TotalQuantity` FROM (((`category` join `product` on(`category`.`CategoryID` = `product`.`CategoryID`)) join `ordersdetail` on(`product`.`ProductID` = `ordersdetail`.`ProductID`)) join `orders` on(`ordersdetail`.`OrdersID` = `orders`.`OrdersID`)) WHERE `category`.`CategoryID` = 10 AND `category`.`Status` = 1 AND `orders`.`Date` >= last_day(current_timestamp()) - interval dayofmonth(last_day(current_timestamp())) - 1 day - interval 1 month AND `orders`.`Date` < last_day(current_timestamp()) - interval dayofmonth(last_day(current_timestamp())) - 1 day GROUP BY `product`.`ProductID`, date_format(`orders`.`Date`,'%M') ;

-- --------------------------------------------------------

--
-- Structure for view `numberofproducts`
--
DROP TABLE IF EXISTS `numberofproducts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `numberofproducts`  AS SELECT `supplier`.`SupplierID` AS `SupplierID`, `supplier`.`Name` AS `Supplier`, `supplier`.`Address` AS `Address`, `supplier`.`Telephone` AS `Telephone`, `supplier`.`Notes` AS `SupplierType`, count(`product`.`ProductID`) AS `Products_count` FROM (((`purchase` join `supplier` on(`purchase`.`SupplierID` = `supplier`.`SupplierID`)) join `purchasedetail` on(`purchase`.`PurchaseID` = `purchasedetail`.`PurchaseID`)) join `product` on(`purchasedetail`.`ProductID` = `product`.`ProductID`)) WHERE `purchase`.`Status` = 1 AND `product`.`Status` = 1 GROUP BY `supplier`.`SupplierID`, `supplier`.`Name`, `supplier`.`Address`, `supplier`.`Telephone`, `supplier`.`Notes`, `purchase`.`Status`, `product`.`Status` ORDER BY count(`product`.`ProductID`) DESC LIMIT 0, 100 ;

-- --------------------------------------------------------

--
-- Structure for view `returneditems`
--
DROP TABLE IF EXISTS `returneditems`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `returneditems`  AS SELECT `product`.`ProductID` AS `ProductID`, `category`.`Name` AS `Category`, `product`.`Description` AS `ReturnedProduct`, sum(`returns`.`Quantity`) AS `Quantity` FROM (((`returns` join `ordersdetail` on(`returns`.`OrdersDetail` = `ordersdetail`.`OrdersDetail`)) join `product` on(`ordersdetail`.`ProductID` = `product`.`ProductID`)) join `category` on(`product`.`CategoryID` = `category`.`CategoryID`)) WHERE `returns`.`Status` = 1 GROUP BY `product`.`ProductID`, `category`.`Name`, `product`.`Description`, `returns`.`Status` ;
