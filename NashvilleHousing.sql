Select *
from PortfolioProject..NashvilleHousing

--Standardize Data Formet and Update

Select SaleDate, convert(date, SaleDate)
from PortfolioProject..NashvilleHousing


alter table NashvilleHousing
add SaleDateConverted Date
update NashvilleHousing
set SaledateConverted = convert(date, SaleDate)



--Populate Property Address data

Select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress= isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null



--Breaking out Address into Individual Column (Address, City, State)


Select PropertyAddress
from PortfolioProject..NashvilleHousing

select
substring (PropertyAddress,  1, charindex(',', PropertyAddress)-1) as address,
substring (PropertyAddress, charindex(',',PropertyAddress)+1, len(PropertyAddress)) as atate
from PortfolioProject..NashvilleHousing


alter table PortfolioProject..NashvilleHousing
add PropertysplitAddress nvarchar(255)
update PortfolioProject..NashvilleHousing
set PropertysplitAddress = substring (PropertyAddress,  1, charindex(',', PropertyAddress)-1)


alter table PortfolioProject..NashvilleHousing
add PropertysplitCity nvarchar(255)
update PortfolioProject..NashvilleHousing
set PropertysplitCity = substring (PropertyAddress, charindex(',',PropertyAddress)+1, len(PropertyAddress))