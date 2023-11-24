SELECT * from NashvilleHousing

Select  NashvilleHousing.SaleDate, CONVERT(date,NashvilleHousing.SaleDate)
from NashvilleHousing
ALTER TABLE NashvilleHousing ALTER COLUMN SaleDate DATE
Update NashvilleHousing
set SaleDate= CONVERT(date,NashvilleHousing.SaleDate)

Select *
from NashvilleHousing


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
Update a
set propertyaddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Select SUBSTRING( NashvilleHousing.PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(NashvilleHousing.PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(NashvilleHousing.PropertyAddress)) as address
from NashvilleHousing

Alter table NashvilleHousing
Add Propertysplitaddress nvarchar (255)

Update NashvilleHousing
Set Propertysplitaddress= SUBSTRING( NashvilleHousing.PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table NashvilleHousing
Add Propertysplitcity nvarchar (255)

Update  NashvilleHousing
Set Propertysplitcity= SUBSTRING(NashvilleHousing.PropertyAddress,CHARINDEX(',',PropertyAddress)+1
,LEN(NashvilleHousing.PropertyAddress))

Select *
from NashvilleHousing

Select NashvilleHousing.OwnerAddress
from NashvilleHousing

Select PARSENAME(Replace (OwnerAddress, ',','.'), 3),
PARSENAME(Replace (OwnerAddress, ',','.'), 2),
PARSENAME(Replace (OwnerAddress, ',','.'), 1)
From NashvilleHousing

Alter table NashvilleHousing
Add Ownersplitaddress nvarchar (255)

Update  NashvilleHousing
Set Ownersplitaddress =  PARSENAME(Replace (OwnerAddress, ',','.'), 3)

Alter table NashvilleHousing
Add Ownersplitcity nvarchar (255)

Update  NashvilleHousing
Set Ownersplitcity =  PARSENAME(Replace (OwnerAddress, ',','.'), 2)

Alter table NashvilleHousing
Add Ownersplitstate nvarchar (255)

Update  NashvilleHousing
Set Ownersplitstate =  PARSENAME(Replace (OwnerAddress, ',','.'), 1)

Select *
from NashvilleHousing

Select NashvilleHousing.SoldAsVacant,COUNT( NashvilleHousing.SoldAsVacant)
from NashvilleHousing
group by NashvilleHousing.SoldAsVacant
order by 2

Select NashvilleHousing.SoldAsVacant
,case when NashvilleHousing.SoldAsVacant='Y' then 'Yes'
      when NashvilleHousing.SoldAsVacant='N' then 'No'
	  Else SoldAsVacant
End
from NashvilleHousing

Update NashvilleHousing
set NashvilleHousing.SoldAsVacant=case when NashvilleHousing.SoldAsVacant='Y' then 'Yes'
      when NashvilleHousing.SoldAsVacant='N' then 'No'
	  Else SoldAsVacant
End

with RowNumCTE AS
(Select *,Row_number()OVER (Partition by ParcelID, PropertyAddress,Saleprice,Saledate,LegalReference
ORDER BY UniqueID) row_num
From NashvilleHousing)
select *
from RowNumCTE
where row_num>1
order by PropertyAddress

with RowNumCTE AS
(Select *,Row_number()OVER (Partition by ParcelID, PropertyAddress,Saleprice,Saledate,LegalReference
ORDER BY UniqueID) row_num
From NashvilleHousing)
Delete 
from RowNumCTE
where row_num>1

Alter table NashvilleHousing
drop column owneraddress,taxdistrict,propertyaddress

select *
from NashvilleHousing

