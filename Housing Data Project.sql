
-----------------------------

--STANDARDISED DATE FORMAT


--1. WE SEE DATE FORMAT NEEDS CHANGING, NAMELY REMOVING TIMESTAMP

SELECT SaleDate
FROM dbo.NashvilleHousingData


--2. ADDED A COLUMN
ALTER TABLE dbo.nashvillehousingdata
ADD SaleDateConverted DATE;


--3. CONVERT NEW TABLE TO CORRECT FORMAT
Update dbo.nashvillehousingdata
SET SaleDateConverted = CONVERT(DATE,SALEDATE)


--4. SELECT NEW TABLE WITH CORRECT FORMAT
SELECT SALEDATECONVERTED
FROM dbo.NashvilleHousingData

------------------------------------------------------------------

--POPULATE PROPERTY ADDRESS DATA

--THERE WERE EXAMPLES OF DUPE PARCEL ID WHERE ONE ROW WOULD HAVE ADDRESS POPULATED AND OTHERS WOULDN'T,
--DESPITE ADDRESS BEING IDENTICAL
--SO TO FIX THIS, CREATED ANOTHER TABLE JOINED ON PARCEL ID AND UNIQUE ID, WHERE FIRST TABLE HAD NULL.
--USED ISNULL FUNCTION TO SET ALL NULLS FROM TABLE A TO MATCH PROPERTY ADDRESS FROM TABLE B


SELECT *
FROM NashvilleHousingData
ORDER BY ParcelID

SELECT a.propertyaddress, a.parcelid, b.propertyaddress,  b.parcelid, ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousingData a
join NashvilleHousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousingData a
join NashvilleHousingData b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null



--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)

SELECT PropertyAddress
FROM NashvilleHousingData
--ORDER BY ParcelID

SELECT SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as address,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(PropertyAddress))  as address

FROM NashvilleHousingData

--------------

ALTER TABLE NashvilleHousingData
ADD PropertySplitCity2 nvarchar(255);

UPDATE NashvilleHousingData
SET PropertySplitCity2 = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(PropertyAddress))



ALTER TABLE NashvilleHousingData
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)



SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
FROM NashvilleHousingData


--DONE
ALTER TABLE NashvilleHousingData
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)



--DONE
ALTER TABLE NashvilleHousingData
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)



--DONE
ALTER TABLE NashvilleHousingData
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)


----------------------------------------------------------------------------


--CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'N' THEN 'NO'
     WHEN SoldAsVacant = 'Y' THEN 'YES'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousingData
ORDER BY SoldAsVacant


ALTER TABLE NashvilleHousingData
ADD SoldAsVacant1 nvarchar(255);

UPDATE NashvilleHousingData
SET SoldAsVacant1 = CASE WHEN SoldAsVacant = 'N' THEN 'No'
     WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 ELSE SoldAsVacant
	 END


---------------------------------------------------------------------


--REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY PARCELID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM NashvilleHousingData)

SELECT *
FROM RowNumCTE
WHERE row_num > 1


-----------------------------------------------------------------

--DELETE UNUSED COLUMNS


SELECT *
FROM NashvilleHousingData

ALTER TABLE NashvilleHousingData
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousingData
DROP COLUMN saledate