

--cleaning data in SQL query in  SQL SERVER MANAGEMENT STIDIO

--standardize Data Format
SELECT *
FROM sql_project..NashVillehousing

SELECT Sale_Date,cast(saleDate AS date) Date, CONVERT(date,saledate)
FROM sql_project..NashVillehousing

update Nashvillehousing
SET Sale_Date = CAST(SaleDate AS date)

ALTER TABLE Nashvillehousing
ADD Sale_Date DATE

--populate Property Adress data
SELECT a.[UniqueID ],a.PropertyAddress,b.[UniqueID ],b.PropertyAddress,NULLIF(a.PropertyAddress, b.PropertyAddress)
FROM sql_project..NashVillehousing a JOIN sql_project..NashVillehousing b ON a.ParcelID = b.ParcelID
AND  a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS Null

UPDATE a
SET a.Propertyaddress = NULLIF(a.PropertyAddress, b.PropertyAddress)
FROM sql_project..NashVillehousing a JOIN sql_project..NashVillehousing b ON a.ParcelID = b.ParcelID
AND  a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS Null


--Breaking out adress into individual columns(adress,city,state)
SELECT PropertyAddress, SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) Property_Address,
       SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) Address_city
FROM sql_project..Nashvillehousing

ALTER TABLE sql_project..Nashvillehousing
Drop column  Property_Address

ALTER TABLE sql_project..Nashvillehousing
ADD  Property_Address nvarchar(255)

update sql_project..NashVilleHousing
SET Property_Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE sql_project..Nashvillehousing
ADD Property_city nvarchar(255)

update sql_project..Nashvillehousing
SET Property_city = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

--seperate owner address 

SELECT  PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
FROM sql_project..NashVilleHousing

ALTER TABLE sql_project..Nashvillehousing
ADD  owner_address nvarchar(255)

update sql_project..Nashvillehousing
SET owner_address = PARSENAME(replace(OwnerAddress,',','.'),3)

ALTER TABLE sql_project..Nashvillehousing
ADD  owners_city nvarchar(255)


update sql_project..Nashvillehousing
SET owners_city = PARSENAME(replace(OwnerAddress,',','.'),2)


ALTER TABLE sql_project..Nashvillehousing
ADD  owners_state nvarchar(255)

update sql_project..Nashvillehousing
SET owners_state = PARSENAME(replace(OwnerAddress,',','.'),1)

--change Y and N to YES and NO

SELECT DISTINCT(SoldAsVacant),count(SoldAsVacant)
FROM sql_project..NashVilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
 CASE WHEN  SoldAsVacant = 'Y' THEN  'YES' 
      WHEN  SoldAsVacant = 'N' THEN  'NO'
 ELSE SoldAsVacant  
 END AS Sold_vacant
FROM sql_project..NashVilleHousing

UPDATE sql_project..NashVilleHousing
SET SoldAsVacant = CASE WHEN  SoldAsVacant = 'Y' THEN  'YES' 
      WHEN  SoldAsVacant = 'N' THEN  'NO'
 ELSE SoldAsVacant  
 END 

 --Remove Dublicates
  SELECT * 
 FROM sql_project..NashVilleHousing


 WITH RowNumCTE AS (SELECT *, ROW_Number() OVER (Partition BY 
                            parcelid,saledate,
							propertyAddress,
							saledate,
							legalReference
							,landvalue 
							Order BY parcelid) row_num
 FROM sql_project..NashVilleHousing )

SELECT * FROM RowNumCTE
 WHERE ROW_num > 1

 --Delete empty colums
   SELECT * 
 FROM sql_project..NashVilleHousing

 ALTER TABLE sql_project..NashVilleHousing
 DROP COLUMN Owneraddress, TaxDistrict, Propertyaddress


