# Data Cleaning
select * from `Nashville Housing Data for Data Cleaning`;
# Standardize format of Date

select saleDate from `Nashville Housing Data for Data Cleaning`;

select SaleDate, CONVERT(SaleDate, DATE) from `Nashville Housing Data for Data Cleaning`;

update `Nashville Housing Data for Data Cleaning`
set SaleDate = CONVERT(SaleDate, DATE);

alter table `Nashville Housing Data for Data Cleaning`
add saleDateConverted DATE;

update `Nashville Housing Data for Data Cleaning`
set `Nashville Housing Data for Data Cleaning`.saleDateConverted = CONVERT(SaleDate, DATE);

select saleDateConverted, CONVERT(SaleDate, DATE) from `Nashville Housing Data for Data Cleaning`;


# Populate property address data

select PropertyAddress from `Nashville Housing Data for Data Cleaning` where PropertyAddress is null;

select * from `Nashville Housing Data for Data Cleaning` where PropertyAddress is null;

select * from `Nashville Housing Data for Data Cleaning` order by ParcelID;

select ifnull(a.PropertyAddress, b.PropertyAddress)
from `Nashville Housing Data for Data Cleaning` a
join `Nashville Housing Data for Data Cleaning` b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null;

select PropertyAddress from `Nashville Housing Data for Data Cleaning` where PropertyAddress is null

update `Nashville Housing Data for Data Cleaning`
set PropertyAddress = "No Address" where PropertyAddress is null;



# Breaking out address into individual columns(Address, City State)

select PropertyAddress from `Nashville Housing Data for Data Cleaning`;

select SUBSTRING_INDEX(PropertyAddress, ',', 1) as Address,
       SUBSTRING_INDEX(PropertyAddress, ',', -1) as City from `Nashville Housing Data for Data Cleaning`


alter table `Nashville Housing Data for Data Cleaning` add PropertySplitAddress NVARCHAR(255);

update `Nashville Housing Data for Data Cleaning`
set PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

alter table `Nashville Housing Data for Data Cleaning` add PropertySplitCity nvarchar(255);

update `Nashville Housing Data for Data Cleaning`
set `Nashville Housing Data for Data Cleaning`.PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);

select PropertySplitCity, PropertySplitAddress, PropertyAddress from `Nashville Housing Data for Data Cleaning`;

select OwnerAddress
from `Nashville Housing Data for Data Cleaning`;


select OwnerAddress,
    substring_index(OwnerAddress, ',', 1),
    substring_index(OwnerAddress, ',', -1),
    substring_index(substring_index(OwnerAddress, ',', -2), ',', 1)
from `Nashville Housing Data for Data Cleaning`;


alter table `Nashville Housing Data for Data Cleaning` add OwnerSplitAddress nvarchar(255);
alter table `Nashville Housing Data for Data Cleaning` add OwnerSplitCity nvarchar(255);
alter table `Nashville Housing Data for Data Cleaning` add OwnerSplitState nvarchar(255);

update `Nashville Housing Data for Data Cleaning` set
                                                      OwnerAddress = "NoAddress"
where OwnerAddress is null;
update `Nashville Housing Data for Data Cleaning` set
    OwnerSplitAddress = substring_index(OwnerAddress, ',', 1),
    OwnerSplitCity = substring_index(substring_index(OwnerAddress, ',', -2), ',', 1),
    OwnerSplitState = substring_index(OwnerAddress, ',', -1);

select OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState from `Nashville Housing Data for Data Cleaning`;


# Change Y an N to Yes and No in sold as Vacant
select DISTINCT SoldAsVacant, count(SoldAsVacant) from `Nashville Housing Data for Data Cleaning` group by SoldAsVacant
order by 2;


select SoldAsVacant,
       case when SoldAsVacant = 'Y' then 'Yes'
            when SoldAsVacant = 'N' then 'No'
            else SoldAsVacant
            end
from `Nashville Housing Data for Data Cleaning`;

update `Nashville Housing Data for Data Cleaning` set
        SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
                            when SoldAsVacant = 'N' then 'No'
                            else SoldAsVacant
                            end;

select DISTINCT SoldAsVacant, count(SoldAsVacant) from `Nashville Housing Data for Data Cleaning` group by SoldAsVacant
order by 2;


# Remove Duplicates
with rowNumCTE as (
select UniqueID, ROW_NUMBER() over (
    PARTITION BY
        ParcelID,
        PropertyAddress,
        SalePrice,
        SaleDate,
        LegalReference
    order by UniqueID) row_num
from `Nashville Housing Data for Data Cleaning`
order by UniqueID)

select * from rowNumCTE where row_num > 1;

delete from `Nashville Housing Data for Data Cleaning` where UniqueID in (12620
,12629
,12639
,12642
,12649
,12676
,12692
,12693
,12702
,27111
,27112
,27113
,27114
,27115
,27116
,27117
,27118
,27119
,27120
,27121
,27122
,27123
,27124
,27125
,27126
,27127
,27128
,27129
,27130
,27131
,27132
,27133
,27134
,27135
,27136
,27137
,27138
,27139
,27141
,27142
,27143
,27144
,27145
,27146
,27147
,27347
,27348
,27349
,27350
,27351
,27352
,27353
,27354
,27355
,27356
,27357
,27358
,27359
,27360
,27361
,27362
,27363
,27364
,27365
,27366
,27367
,27368
,27369
,27370
,27371
,27372
,27373
,27374
,27375
,27376
,27377
,27378
,27379
,27380
,27381
,27382
,27383
,27384
,27385
,27386
,27387
,27388
,27389
,27390
,27391
,27392
,27393
,27394
,27395
,27396
,27397
,27398
,27399
,27400
,27401
,27402
,27403
,27404
);

# Delete Unused Columns

alter table `Nashville Housing Data for Data Cleaning` drop column PropertyAddress;
alter table `Nashville Housing Data for Data Cleaning` drop column OwnerAddress;
alter table `Nashville Housing Data for Data Cleaning` drop column TaxDistrict;