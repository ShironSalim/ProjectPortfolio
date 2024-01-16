---- Cleaning Data in SQL Server

select* 
From new_projects..Nashville_Housing



---------------------------------------------------------------------------------------------
----Standardize Date Format

select SaleDate
From new_Projects..Nashville_Housing


Select SaleDate, Convert(Date,SaleDate)
From new_projects..Nashville_Housing

Update Nashville_Housing
Set SaleDate=Convert(Date,SaleDate)

Alter Table Nashville_Housing
Add SaleDateConvereted Date

Update Nashville_Housing
Set SaleDateConvereted =Convert(Date,SaleDate)

Select SaleDateConvereted, Convert(Date,SaleDate)
From new_projects..Nashville_Housing


-----------------------------------------------------------------------------------------------
----Populate Property address Data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from new_projects..Nashville_Housing a
Join new_projects..Nashville_Housing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


Update a
set a.PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from new_projects..Nashville_Housing a
Join new_projects..Nashville_Housing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


------------------------------------------------------------------------------------------------

----Breaking out Address into Individual coloumns(Address,State)


Select PropertyAddress
From new_projects..Nashville_Housing


-----------------------------------------------------------------------------------------
---where PropertyAddress is null
---order by ParcelID

select
PARSENAME(REPLACE(PropertyAddress,',','.'),2)
,Parsename(Replace(PropertyAddress,',','.'),1)
From new_projects..Nashville_Housing

Alter Table Nashville_Housing
add PropertysplitAddress Nvarchar(255);

update Nashville_Housing
set PropertysplitAddress=PARSENAME(REPLACE(PropertyAddress,',','.'),2)

Alter Table Nashville_Housing
add Propertysplitstate nvarchar(255)

update Nashville_Housing
set Propertysplitstate=Parsename(Replace(PropertyAddress,',','.'),1)


select*
from new_projects..Nashville_Housing

-----------------------------------------------------------------------------------------------
----Breaking out owneraddress into Individual coloumns(Address,city,State)

Select
PARSENAME(Replace(OwnerAddress,',','.'),3)
,PARSENAME(Replace(OwnerAddress,',','.'),2)
,PARSENAME(Replace(OwnerAddress,',','.'),1)
from new_projects..Nashville_Housing

Alter Table Nashville_Housing
add Ownersplitaddress Nvarchar(255)

Update Nashville_Housing
set Ownersplitaddress=PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table Nashville_Housing
add Ownersplitcity Nvarchar(255)

Update Nashville_Housing
set Ownersplitcity = PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table Nashville_Housing
add Ownersplitstate Nvarchar(255)


Update Nashville_Housing
set Ownersplitstate = PARSENAME(Replace(OwnerAddress,',','.'),1)


select*
from new_projects..Nashville_Housing

--------------------------------------------------------------------------------------------
----Change Y and N to Yes and No in "Solid as vacant" fields

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From new_projects..Nashville_Housing
Group by SoldAsVacant
order by 2




select SoldAsVacant
,case when SoldAsVacant ='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  end
From new_projects..Nashville_Housing


update Nashville_Housing
set SoldAsVacant= case when SoldAsVacant ='Y' then 'Yes'
      when SoldAsVacant='N' then 'No'
	  else SoldAsVacant
	  end
---------------------------------------------------------------------------
----Remove Duplicates

with RowNumCTE AS(
 select*,
	Row_Number()OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				       UniqueID
					   ) row_num
From new_projects..Nashville_Housing
)

Select*
From RowNumCTE
where row_num>1

---------------------------------------------------------------------------------------
---Order by PropertyAddress

 select*
 From new_projects..Nashville_Housing

 ---------------------------------------------------------------------------------------

 ---Delete Unused Columns

 select*
 From new_projects..Nashville_Housing


 Alter Table new_projects..Nashville_Housing
 Drop Column OwnerAddress,TaxDistrict,PropertyAddress

  Alter Table new_projects..Nashville_Housing
 Drop Column SaleDate