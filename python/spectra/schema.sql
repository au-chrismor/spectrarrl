drop table  if exists access_area;
drop table  if exists antenna;
drop table  if exists antenna_pattern;
drop table  if exists antenna_polarity;
drop table  if exists applic_text_block;
drop table  if exists auth_spectrum_area;
drop table  if exists auth_spectrum_freq;
drop table  if exists bsl;
drop table  if exists bsl_area;
drop table  if exists class_of_station;
drop table  if exists client;
drop table  if exists client_type;
drop table  if exists device_details;
drop table  if exists device_power_pattern;
drop table  if exists fee_status;
drop table  if exists industry_cat;
drop table  if exists licence;
drop table  if exists licence_service;
drop table  if exists licence_status;
drop table  if exists licence_subservice;
drop table  if exists licensing_area;
drop table  if exists nature_of_service;
drop table  if exists reports_text_block;
drop table  if exists satellite;
drop table  if exists site;

create table client_type(
 TYPE_ID		INTEGER PRIMARY KEY,
 NAME     VARCHAR2(240)
);
create index ix_client_type_001 on client_type(NAME);

create table fee_status(
 FEE_STATUS_ID		 INTEGER PRIMARY KEY,
 FEE_STATUS_TEXT VARCHAR2(100)
);
create index ix_fee_status_001 on fee_status(FEE_STATUS_TEXT);

create table industry_cat(
 CAT_ID			NUMBER PRIMARY KEY,
 DESCRIPTION            VARCHAR2(240),
 NAME                   VARCHAR2(120)
);
create index ix_industry_cat_001 on industry_cat(DESCRIPTION);
create index ix_industry_cat_002 on industry_cat(NAME);

create table client(
 CLIENT_NO		NUMBER PRIMARY KEY,
 LICENCEE               VARCHAR2(201),
 TRADING_NAME           VARCHAR2(100),
 ACN                    VARCHAR2(100),
 ABN                    VARCHAR2(14),
 POSTAL_STREET          VARCHAR2(600),
 POSTAL_SUBURB          VARCHAR2(480),
 POSTAL_STATE           VARCHAR2(36),
 POSTAL_POSTCODE        VARCHAR2(72),
 CAT_ID                 INTEGER,
 CLIENT_TYPE_ID         INTEGER,
 FEE_STATUS_ID          INTEGER
);
alter table client add constraint fk_client_001 foreign key (CLIENT_TYPE_ID) references client_type(TYPE_ID);
alter table client add constraint fk_client_002 foreign key (FEE_STATUS_ID) references fee_status(FEE_STATUS_ID);
alter table client add constraint fk_client_003 foreign key (CAT_ID) references industry_cat(CAT_ID);
create index ix_client_001 on client(LICENCEE);
create index ix_client_002 on client(TRADING_NAME);
create index ix_client_003 on client(ACN);
create index ix_client_004 on client(ABN);
create index ix_client_005 on client(POSTAL_POSTCODE, POSTAL_STATE, POSTAL_SUBURB, POSTAL_STREET);

create table bsl_area(
 AREA_CODE		VARCHAR2(256) PRIMARY KEY,
 AREA_NAME		VARCHAR2(256)
);
create index ix_bsl_area on bsl_area(AREA_NAME);

create table bsl(
 BSL_NO                 VARCHAR2(31) PRIMARY KEY,
 MEDIUM_CATEGORY        VARCHAR2(4000),
 REGION_CATEGORY        VARCHAR2(4000),
 COMMUNITY_INTEREST     VARCHAR2(4000),
 BSL_STATE              VARCHAR2(4000),
 DATE_COMMENCED         DATE,
 ON_AIR_ID              VARCHAR2(511),
 CALL_SIGN              VARCHAR2(255),
 IBL_TARGET_AREA        VARCHAR2(511),
 AREA_CODE              VARCHAR2(256),
 REFERENCE              VARCHAR2(63)
);
alter table bsl add constraint fk_bsl_001 foreign key (AREA_CODE) references bsl_area(AREA_CODE);
create index ix_bsl_001 on bsl(ON_AIR_ID);
create index ix_bsl_002 on bsl(CALL_SIGN);

create table licence_service(
 SV_ID			NUMBER(10) PRIMARY KEY,
 SV_NAME                VARCHAR2(63)
);
create index ix_licence_service_001 on licence_service(SV_NAME);

create table licence_subservice(
 SS_ID			NUMBER(10) PRIMARY KEY,
 SV_SV_ID               NUMBER(10),
 SS_NAME                VARCHAR2(95),
 FOREIGN KEY (SV_SV_ID) REFERENCES licence_service(SV_ID)
);
create index ix_licence_subservice_001 on licence_subservice(SS_NAME);

create table licence_status(
 STATUS			VARCHAR2(10),
 STATUS_TEXT            VARCHAR2(511)
);
create index ix_licence_status_001 on licence_status(STATUS_TEXT);

create table licensing_area(
 LICENSING_AREA_ID	VARCHAR2(31) PRIMARY KEY,
 DESCRIPTION            VARCHAR2(511)
);
create index ix_licensing_area_001 on licensing_area(DESCRIPTION);

create table licence(
 LICENCE_NO		VARCHAR2(63) PRIMARY KEY,
 CLIENT_NO              INTEGER,
 SV_ID                  INTEGER(10),
 SS_ID                  INTEGER(10),
 LICENCE_TYPE_NAME      VARCHAR2(63),
 LICENCE_CATEGORY_NAME  VARCHAR2(95),
 DATE_ISSUED            DATE,
 DATE_OF_EFFECT         DATE,
 DATE_OF_EXPIRY         DATE,
 STATUS                 VARCHAR2(10),
 STATUS_TEXT            VARCHAR2(256),
 AP_ID                  INTEGER(10),
 AP_PRJ_IDENT           VARCHAR2(511),
 SHIP_NAME              VARCHAR2(255),
 BSL_NO                 VARCHAR2(31)
);
alter table licence add constraint fk_licence_001 foreign key (CLIENT_NO) references client(CLIENT_NO);
alter table licence add constraint fk_licence_002 foreign key (SV_ID) references licence_service(SV_ID);
alter table licence add constraint fk_licence_003 foreign key (SS_ID) references licence_subservice(SS_ID);
alter table licence add constraint fk_licence_004 foreign key (STATUS) references licence_status(STATUS);
alter table licence add constraint fk_licence_005 foreign key (BSL_NO) references bsl(BSL_NO);

create table access_area(
 AREA_ID		NUMBER(10) PRIMARY KEY,
 AREA_CODE              VARCHAR2(256),
 AREA_NAME              VARCHAR2(256),
 AREA_CATEGORY          INTEGER
);
create index ix_access_area_001 on access_area(AREA_CODE);
create index ix_access_area_002 on access_area(AREA_NAME);
create index ix_access_area_003 on access_area(AREA_CATEGORY);


create table antenna(
 ANTENNA_ID		VARCHAR2(31) PRIMARY KEY,
 GAIN                   DECIMAL,
 FRONT_TO_BACK          DECIMAL,
 H_BEAMWIDTH            DECIMAL,
 V_BEAMWIDTH            DECIMAL,
 BAND_MIN_FREQ          DECIMAL,
 BAND_MIN_FREQ_UNIT     VARCHAR2(3),
 BAND_MAX_FREQ          DECIMAL,
 BAND_MAX_FREQ_UNIT     VARCHAR2(3),
 ANTENNA_SIZE           DECIMAL,
 ANTENNA_TYPE           VARCHAR2(240),
 MODEL                  VARCHAR2(80),
 MANUFACTURER           VARCHAR2(255)
);
create index ix_antenna_001 on antenna(ANTENNA_TYPE);
create index ix_antenna_002 on antenna(MANUFACTURER, MODEL);

create table antenna_pattern(
 AP_ID INTEGER PRIMARY KEY AUTO_INCREMENT,
 ANTENNA_ID		VARCHAR2(31),
 AZ_TYPE                VARCHAR2(15),
 ANGLE_REF              DECIMAL,
 ANGLE                  DECIMAL,
 ATTENUATION            DECIMAL
);
alter table antenna_pattern add constraint fk_antenna_pattern_001 foreign key (ANTENNA_ID) references antenna(ANTENNA_ID);
create table antenna_polarity(
 POLARISATION_CODE	VARCHAR2(3),
 POLARISATION_TEXT      VARCHAR2(50)
);
create index ix_antenna_polarity on antenna_polarity(POLARISATION_TEXT);

create table applic_text_block(
 APTB_ID		NUMBER PRIMARY KEY,
 APTB_TABLE_PREFIX	VARCHAR2(30),
 APTB_TABLE_ID          DECIMAL(10),
 LICENCE_NO             VARCHAR2(63),
 APTB_DESCRIPTION       VARCHAR2(255),
 APTB_CATEGORY          VARCHAR2(255),
 APTB_TEXT              VARCHAR2(4000),
 APTB_ITEM              VARCHAR2(15)
);
alter table applic_text_block add constraint fk_applic_text_block_001 foreign key (LICENCE_NO) references licence(LICENCE_NO);

create table reports_text_block(
 RTB_ID         INTEGER PRIMARY KEY AUTO_INCREMENT,
 RTB_ITEM		VARCHAR2(15),
 RTB_CATEGORY           VARCHAR2(255),
 RTB_DESCRIPTION        VARCHAR2(255),
 RTB_START_DATE         DATE,
 RTB_END_DATE           DATE,
 RTB_TEXT               VARCHAR2(4000)
);
alter table reports_text_block add constraint fk_reports_text_block_001 foreign key (RTB_ITEM) references applic_text_block(APTB_ITEM);

create table auth_spectrum_area(
 ASA_ID             INTEGER PRIMARY KEY AUTO_INCREMENT,
 LICENCE_NO  		VARCHAR2(63),
 AREA_CODE              VARCHAR2(256),
 AREA_NAME              VARCHAR2(256),
 AREA_DESCRIPTION       BLOB
);
alter table auth_spectrum_area add constraint fk_auth_spectrum_area_001 foreign key (LICENCE_NO) references licence(LICENCE_NO);
create index ix_auth_spectrum_area_001 on auth_spectrum_area(LICENCE_NO);
create index ix_auth_spectrum_area_002 on auth_spectrum_area(AREA_CODE);
create index ix_auth_spectrum_area_003 on auth_spectrum_area(AREA_NAME);

create table auth_spectrum_freq(
 ASF_ID INTEGER PRIMARY KEY AUTOINCREMENT,
 LICENCE_NO		VARCHAR2(63),
 AREA_CODE              VARCHAR2(256),
 AREA_NAME              VARCHAR2(256),
 LW_FREQUENCY_START     DECIMAL,
 LW_FREQUENCY_END       DECIMAL,
 UP_FREQUENCY_START     DECIMAL,
 UP_FREQUENCY_END       DECIMAL
);
alter table auth_spectrum_freq add constraint fk_auth_spectrum_freq_001 foreign key (LICENCE_NO) references licence(LICENCE_NO);
create index ix_auth_spectrum_freq_001 on auth_spectrum_freq(LICENCE_NO);
create index ix_auth_spectrum_freq_002 on auth_spectrum_freq(AREA_CODE);
create index ix_auth_spectrum_freq_003 on auth_spectrum_freq(AREA_NAME);

create table class_of_station(
 CODE			VARCHAR2(31) PRIMARY KEY,
 DESCRIPTION            VARCHAR2(511)
);
create index ix_class_of_station_001 on class_of_station(DESCRIPTION);

create table device_details(
 SDD_ID   				NUMBER(10) PRIMARY KEY,
 LICENCE_NO                             VARCHAR2(63),
 DEVICE_REGISTRATION_IDENTIFIER         VARCHAR2(63),
 FORMER_DEVICE_IDENTIFIER               VARCHAR2(63),
 AUTHORISATION_DATE                     DATE,
 CERTIFICATION_METHOD                   VARCHAR2(255),
 GROUP_FLAG                             VARCHAR2(255),
 SITE_RADIUS                            DECIMAL,
 FREQUENCY                              DECIMAL,
 BANDWIDTH                              DECIMAL,
 CARRIER_FREQ                           DECIMAL,
 EMISSION                               VARCHAR2(63),
 DEVICE_TYPE                            VARCHAR2(1),
 TRANSMITTER_POWER                      DECIMAL,
 TRANSMITTER_POWER_UNIT                 VARCHAR2(31),
 SITE_ID                                VARCHAR2(31),
 ANTENNA_ID                             VARCHAR2(31),
 POLARISATION                           VARCHAR2(3),
 AZIMUTH                                DECIMAL,
 HEIGHT                                 DECIMAL,
 TILT                                   DECIMAL,
 FEEDER_LOSS                            DECIMAL,
 LEVEL_OF_PROTECTION                    DECIMAL,
 EIRP                                   DECIMAL,
 EIRP_UNIT                              VARCHAR2(31),
 SV_ID                                  DECIMAL(10),
 SS_ID                                  DECIMAL(10),
 EFL_ID                                 VARCHAR2(40),
 EFL_FREQ_IDENT                         VARCHAR2(31),
 EFL_SYSTEM                             VARCHAR2(63),
 LEQD_MODE                              VARCHAR2(1),
 RECEIVER_THRESHOLD                     DECIMAL,
 AREA_AREA_ID                           DECIMAL(10),
 CALL_SIGN                              VARCHAR2(255),
 AREA_DESCRIPTION                       VARCHAR2(9),
 AP_ID                                  DECIMAL(10),
 CLASS_OF_STATION_CODE                  VARCHAR2(31),
 SUPPLIMENTAL_FLAG                      VARCHAR2(199),
 EQ_FREQ_RANGE_MIN                      DECIMAL,
 EQ_FREQ_RANGE_MAX                      DECIMAL,
 NATURE_OF_SERVICE_ID                   VARCHAR2(3),
 HOURS_OF_OPERATION                     VARCHAR2(11),
 SA_ID                                  DECIMAL(10),
 RELATED_EFL_ID                         DECIMAL,
 EQP_ID                                 DECIMAL(10),
 ANTENNA_MULTI_MODE                     VARCHAR2(3),
 POWER_IND                              VARCHAR2(14),
 LPON_CENTER_LONGITUDE                  DECIMAL,
 LPON_CENTER_LATITUDE                   DECIMAL,
 TCS_ID                                 DECIMAL(10),
 TECH_SPEC_ID                           VARCHAR2(63),
 DROPTHROUGH_ID                         VARCHAR2(63),
 STATION_TYPE                           VARCHAR2(511),
 STATION_NAME                           VARCHAR2(63)
);
 alter table device_details add constraint fk_device_details_001 foreign key (LICENCE_NO) references licence(LICENCE_NO);
 alter table device_details add constraint fk_device_details_002 foreign key (SITE_ID) references site(SITE_ID);
 alter table device_details add constraint fk_device_details_003 foreign key (ANTENNA_ID) references antenna(ANTENNA_ID);
 alter table device_details add constraint fk_device_details_004 foreign key (POLARISATION) references antenna_polarity(POLARISATION_CODE);
 alter table device_details add constraint fk_device_details_005 foreign key (SV_ID) references licence_service(SV_ID);
 alter table device_details add constraint fk_device_details_006 foreign key (SS_ID) references licence_subservice(SS_ID);
 alter table device_details add constraint fk_device_details_007 foreign key (AREA_AREA_ID) references access_area(AREA_ID);
 alter table device_details add constraint fk_device_details_008 foreign key (CLASS_OF_STATION_CODE) references class_of_station(CODE);
 alter table device_details add constraint fk_device_details_009 foreign key (NATURE_OF_SERVICE_ID) references nature_of_service(CODE);
 alter table device_details add constraint fk_device_details_010 foreign key (SA_ID) satellite(SA_ID);
 create index ix_device_details_001 on device_details(DEVICE_REGISTRATION_IDENTIFIER);

 create table device_power_pattern(
 DPP_ID             INTEGER PRIMARY KEY AUTO_INCREMENT,
 SDD_ID   				DECIMAL(10),
 REGISTRATION_IDENTIFIER VARCHAR2(63),
 START_ANGLE DECIMAL(10),
 STOP_ANGLE DECIMAL(10),
 POWER DECIMAL(10),
);
 alter table device_power_pattern add constraint fk_device_power_pattern_001 foreign key (REGISTRATION_IDENTIFIER) references device_details(DEVICE_REGISTRATION_IDENTIFIER);
create index ix_device_power_pattern_001 on device_power_pattern(SDD_ID,REGISTRATION_IDENTIFIER);

create table nature_of_service(
 CODE			VARCHAR2(31) PRIMARY KEY,
 DESCRIPTION            VARCHAR2(511)
);
create index ix_nature_of_service_001 on nature_of_service(DESCRIPTION);

create table satellite(
 SA_ID			NUMBER(10) PRIMARY KEY,
 SA_SAT_NAME            VARCHAR2(31),
 SA_SAT_LONG_NOM        DECIMAL,
 SA_SAT_INCEXC          DECIMAL,
 SA_SAT_GEO_POS         VARCHAR2(1),
 SA_SAT_MERIT_G_T       DECIMAL
);
create index ix_satellite_001 on satellite(SA_SAT_NAME);

create table site(
 SITE_ID		VARCHAR2(31) PRIMARY KEY,
 LATITUDE               DECIMAL,
 LONGITUDE              DECIMAL,
 NAME                   VARCHAR2(767),
 STATE                  VARCHAR2(80),
 LICENSING_AREA_ID      DECIMAL,
 POSTCODE               VARCHAR2(18),
 SITE_PRECISION         VARCHAR2(31),
 ELEVATION              DECIMAL,
 HCIS_L2		VARCHAR2(31)
);
create index ix_site_001 on site(NAME);

