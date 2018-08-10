create table city
(
  idCity   int(11) unsigned not null
    primary key,
  cityName varchar(45)      not null,
  ZipNum   varchar(45)      not null
);

create table company
(
  idCompany    int(11) unsigned auto_increment
    primary key,
  CompanyName  varchar(45)      not null,
  CompanyTarif decimal unsigned null
);

create table conseil
(
  ConseilId          int(11) unsigned auto_increment
    primary key,
  ConseilName        varchar(50)                         not null,
  ConseilDescription varchar(255)                        not null,
  Create_date        datetime default CURRENT_TIMESTAMP  not null,
  Last_update        timestamp default CURRENT_TIMESTAMP not null
  on update CURRENT_TIMESTAMP
);

create table periode
(
  periodeId          int(11) unsigned auto_increment,
  PeriodeName        varchar(50)  not null,
  PeriodeDescription varchar(255) not null,
  constraint Periode_periodeId_uindex
  unique (periodeId)
)
  comment 'periode of time in order to calculate / compare';

alter table periode
  add primary key (periodeId);

create table tbprofil
(
  ProfilId          int(11) unsigned auto_increment
    primary key,
  ProfilName        varchar(50)   not null,
  ProfilDescription varchar(1000) null
);

create table tbtype_appliance
(
  idType_Appliance   int(11) unsigned auto_increment
    primary key,
  type_ApplianceName varchar(45) not null
);

create table tbappliance
(
  idAppliance      int(11) unsigned auto_increment
    primary key,
  idType_Appliance int(11) unsigned                    not null,
  applianceName    varchar(100)                        not null,
  watts            varchar(100)                        not null,
  create_date      datetime default CURRENT_TIMESTAMP  not null,
  last_update      timestamp default CURRENT_TIMESTAMP not null
  on update CURRENT_TIMESTAMP,
  constraint Type_Appliance_FK
  foreign key (idType_Appliance) references tbtype_appliance (idType_Appliance)
);

create index Type_Appliance_FK_idx
  on tbappliance (idType_Appliance);

create table user
(
  UserId      int auto_increment
    primary key,
  UName       varchar(50)                         not null,
  Surname     varchar(50)                         not null,
  UPassword   varchar(50)                         not null,
  BirthDate   date                                not null,
  Email       varchar(50)                         not null,
  CityId      int(11) unsigned                    not null,
  CompanyId   int(11) unsigned                    not null,
  create_date datetime default CURRENT_TIMESTAMP  not null,
  last_update timestamp default CURRENT_TIMESTAMP not null
  on update CURRENT_TIMESTAMP,
  constraint Utilisateur_AK0
  unique (Email),
  constraint User_City_FK
  foreign key (CityId) references city (idCity)
    on update cascade,
  constraint User_Company_FK
  foreign key (CompanyId) references company (idCompany)
);

create table ocr
(
  ocrId       int auto_increment
    primary key,
  serialNum   varchar(10)                         not null,
  UserId      int                                 not null,
  create_date datetime default CURRENT_TIMESTAMP  not null,
  last_update timestamp default CURRENT_TIMESTAMP not null
  on update CURRENT_TIMESTAMP,
  constraint OCR_Utilisateur0_AK
  unique (UserId),
  constraint OCR_Utilisateur0_FK
  foreign key (UserId) references user (UserId)
);

create table releve
(
  releveId    int(11) unsigned auto_increment
    primary key,
  value       int                                 not null,
  ocrId       int                                 not null,
  Create_date datetime default CURRENT_TIMESTAMP  not null,
  Last_update timestamp default CURRENT_TIMESTAMP not null,
  constraint releve_ocr__fk
  foreign key (ocrId) references ocr (ocrId)
    on update cascade
)
  comment 'recevoir la résultat de l''ocr, chque heure ( total )';

create table tb_log
(
  logId          int(11) unsigned auto_increment
    primary key,
  UserId         int                                 not null,
  logType        varchar(50)                         not null,
  logDescription varchar(4000)                       null,
  Create_date    datetime default CURRENT_TIMESTAMP  not null,
  Last_update    timestamp default CURRENT_TIMESTAMP not null
  on update CURRENT_TIMESTAMP,
  constraint tb_log_user_UserId_fk
  foreign key (UserId) references user (UserId)
    on update cascade
);

create table token
(
  tokenId     int auto_increment
    primary key,
  UserId      int                                 not null,
  Create_date datetime default CURRENT_TIMESTAMP  not null,
  Last_update timestamp default CURRENT_TIMESTAMP not null
  on update CURRENT_TIMESTAMP,
  api_token   varchar(60)                         null,
  constraint token_user_UserId_fk
  foreign key (UserId) references user (UserId)
);

create index User_City_FK_idx
  on user (CityId);

create index User_Company_FK_idx
  on user (CompanyId);

create table userprofil
(
  UserId   int              not null,
  ProfilId int(11) unsigned not null,
  primary key (UserId, ProfilId),
  constraint UserProfil_tbprofil_ProfilId_fk
  foreign key (ProfilId) references tbprofil (ProfilId)
    on update cascade,
  constraint UserProfil_user_UserId_fk
  foreign key (UserId) references user (UserId)
    on update cascade
);

create table usershaveappliances
(
	idUHA int auto_increment
		primary key,
	UserId int not null,
	idAppliance int(11) unsigned not null,
	HeureParMois decimal not null comment 'utilisation des appareilles par mois',
	Create_date datetime default CURRENT_TIMESTAMP null,
	Last_update timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
	constraint usershaveappliances_tbappliance_idAppliance_fk
		foreign key (idAppliance) references kwapp_test.tbappliance (idAppliance)
			on update cascade,
	constraint usershaveappliances_user_UserId_fk
		foreign key (UserId) references kwapp_test.user (UserId)
			on update cascade
)
comment 'calculate per month, in order to obtain the result per day eg , devided the result to 28/29/30/31';
--maybe we have to add a table "mail" in order to keep / auto generate mail content. 

