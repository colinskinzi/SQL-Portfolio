-- Cleaning data

Select *
from PortfolioProject.dbo.NashvilleHousing

--Standardizing Date Format

Select SaleDate2, CONVERT(Date, SaleDate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
Set SaleDate = CONVERT(Date, SaleDate);

alter table NashvilleHousing
add SaleDate2 Date;

/*update NashvilleHousing
set SaleDate2 = CONVERT(Date,SaleDate)*/

-- Populate Porperty Address Data

Select *
from PortfolioProject..NashvilleHousing
where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out address into individual columns(Address, city, State)

Select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
-- Order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


alter table NashvilleHousing
add PropertySplitCity NvarChar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))  

Select OwnerAddress
from PortfolioProject..NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
from PortfolioProject..NashvilleHousing



alter table NashvilleHousing
add OwnerSplitAdress Nvarchar(255);

Update NashvilleHousing
set OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)


alter table NashvilleHousing
add OwnerSplitCity NvarChar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

alter table NashvilleHousing
add OwnerSplitState NvarChar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

--Change Y and N to Yes and NO in Sold aAs Vancant Field. 

Select Distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..NashvilleHousing


-- Remove Duplicates ((code not advice for work environment))


With row_numCTE as(
Select *,
	ROW_NUMBER() Over (
	Partition by parcelID, 
				propertyAddress, 
				salePrice, 
				saleDate, 
				LegalReference
				Order by 
				uniqueID
				) row_num

from PortfolioProject..NashvilleHousing
-- order by ParcelID
)
/* Delete * 
From row_numCTE
where row_num > 1
order by PropertyAddress*/


-- Delete Unused Columns

Select *
from PortfolioProject..NashvilleHousing

alter Table PortfolioProject..NashvilleHousing
drop Column OwnerAddress, TaxDistrict, PropertyAddress


-- Remaning a column in SQL server
-- EXEC sp_rename 'NashvilleHousing.OwnerSplitAdress', 'OwnerSplitAddress', 'Column'  

Select *
from PortfolioProject..NashvilleHousing



















































































