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
 TYPE_ID		NUMBER PRIMARY KEY,
 NAME                   VARCHAR2(240)
);
create index ix_client_type_001 on client_type(NAME);

create table fee_status(
 FEE_STATUS_ID		NUMBER PRIMARY KEY,
 FEE_STATUS_TEXT        VARCHAR2(100)
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
 CAT_ID                 NUMBER,
 CLIENT_TYPE_ID         NUMBER,
 FEE_STATUS_ID          NUMBER,
 FOREIGN KEY (CLIENT_TYPE_ID) REFERENCES client_type(TYPE_ID),
 FOREIGN KEY (FEE_STATUS_ID) REFERENCES fee_status(FEE_STATUS_ID),
 FOREIGN KEY (CAT_ID) REFERENCES industry_cat(CAT_ID)
);
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
 REFERENCE              VARCHAR2(63),
 FOREIGN KEY (AREA_CODE) REFERENCES bsl_area(AREA_CODE)
);
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
 CLIENT_NO              NUMBER,
 SV_ID                  NUMBER(10),
 SS_ID                  NUMBER(10),
 LICENCE_TYPE_NAME      VARCHAR2(63),
 LICENCE_CATEGORY_NAME  VARCHAR2(95),
 DATE_ISSUED            DATE,
 DATE_OF_EFFECT         DATE,
 DATE_OF_EXPIRY         DATE,
 STATUS                 VARCHAR2(10),
 STATUS_TEXT            VARCHAR2(256),
 AP_ID                  NUMBER(10),
 AP_PRJ_IDENT           VARCHAR2(511),
 SHIP_NAME              VARCHAR2(255),
 BSL_NO                 VARCHAR2(31),
 FOREIGN KEY (CLIENT_NO) REFERENCES client(CLIENT_NO),
 FOREIGN KEY (SV_ID) REFERENCES licence_service(SV_ID),
 FOREIGN KEY (SS_ID) REFERENCES licence_subservice(SS_ID),
 FOREIGN KEY (STATUS) REFERENCES licence_status(STATUS),
 FOREIGN KEY (BSL_NO) REFERENCES bsl(BSL_NO)
);

create table access_area(
 AREA_ID		NUMBER(10) PRIMARY KEY,
 AREA_CODE              VARCHAR2(256),
 AREA_NAME              VARCHAR2(256),
 AREA_CATEGORY          NUMBER
);
create index ix_access_area_001 on access_area(AREA_CODE);
create index ix_access_area_002 on access_area(AREA_NAME);
create index ix_access_area_003 on access_area(AREA_CATEGORY);


create table antenna(
 ANTENNA_ID		VARCHAR2(31) PRIMARY KEY,
 GAIN                   NUMBER,
 FRONT_TO_BACK          NUMBER,
 H_BEAMWIDTH            NUMBER,
 V_BEAMWIDTH            NUMBER,
 BAND_MIN_FREQ          NUMBER,
 BAND_MIN_FREQ_UNIT     VARCHAR2(3),
 BAND_MAX_FREQ          NUMBER,
 BAND_MAX_FREQ_UNIT     VARCHAR2(3),
 ANTENNA_SIZE           NUMBER,
 ANTENNA_TYPE           VARCHAR2(240),
 MODEL                  VARCHAR2(80),
 MANUFACTURER           VARCHAR2(255)
);
create index ix_antenna_001 on antenna(ANTENNA_TYPE);
create index ix_antenna_002 on antenna(MANUFACTURER, MODEL);

create table antenna_pattern(
 AP_ID INTEGER PRIMARY KEY AUTOINCREMENT,
 ANTENNA_ID		VARCHAR2(31),
 AZ_TYPE                VARCHAR2(15),
 ANGLE_REF              NUMBER,
 ANGLE                  NUMBER,
 ATTENUATION            NUMBER,
 FOREIGN KEY (ANTENNA_ID) REFERENCES antenna(ANTENNA_ID)
);

create table antenna_polarity(
 POLARISATION_CODE	VARCHAR2(3),
 POLARISATION_TEXT      VARCHAR2(50)
);
create index ix_antenna_polarity on antenna_polarity(POLARISATION_TEXT);

create table applic_text_block(
 APTB_ID		NUMBER PRIMARY KEY,
 APTB_TABLE_PREFIX	VARCHAR2(30),
 APTB_TABLE_ID          NUMBER(10),
 LICENCE_NO             VARCHAR2(63),
 APTB_DESCRIPTION       VARCHAR2(255),
 APTB_CATEGORY          VARCHAR2(255),
 APTB_TEXT              VARCHAR2(4000),
 APTB_ITEM              VARCHAR2(15),
 FOREIGN KEY (LICENCE_NO) REFERENCES licence(LICENCE_NO)
);

create table reports_text_block(
 RTB_ID         INTEGER PRIMARY KEY AUTOINCREMENT,
 RTB_ITEM		VARCHAR2(15),
 RTB_CATEGORY           VARCHAR2(255),
 RTB_DESCRIPTION        VARCHAR2(255),
 RTB_START_DATE         DATE,
 RTB_END_DATE           DATE,
 RTB_TEXT               VARCHAR2(4000),
 FOREIGN KEY (RTB_ITEM) REFERENCES applic_text_block(APTB_ITEM)
);

create table auth_spectrum_area(
 ASA_ID             INTEGER PRIMARY KEY AUTOINCREMENT,
 LICENCE_NO  		VARCHAR2(63),
 AREA_CODE              VARCHAR2(256),
 AREA_NAME              VARCHAR2(256),
 AREA_DESCRIPTION       CLOB,
 FOREIGN KEY (LICENCE_NO) REFERENCES licence(LICENCE_NO)
);
create index ix_auth_spectrum_area_001 on auth_spectrum_area(LICENCE_NO);
create index ix_auth_spectrum_area_002 on auth_spectrum_area(AREA_CODE);
create index ix_auth_spectrum_area_003 on auth_spectrum_area(AREA_NAME);

create table auth_spectrum_freq(
 ASF_ID INTEGER PRIMARY KEY AUTOINCREMENT,
 LICENCE_NO		VARCHAR2(63),
 AREA_CODE              VARCHAR2(256),
 AREA_NAME              VARCHAR2(256),
 LW_FREQUENCY_START     NUMBER,
 LW_FREQUENCY_END       NUMBER,
 UP_FREQUENCY_START     NUMBER,
 UP_FREQUENCY_END       NUMBER,
 FOREIGN KEY (LICENCE_NO) REFERENCES licence(LICENCE_NO)
);
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
 SITE_RADIUS                            NUMBER,
 FREQUENCY                              NUMBER,
 BANDWIDTH                              NUMBER,
 CARRIER_FREQ                           NUMBER,
 EMISSION                               VARCHAR2(63),
 DEVICE_TYPE                            VARCHAR2(1),
 TRANSMITTER_POWER                      NUMBER,
 TRANSMITTER_POWER_UNIT                 VARCHAR2(31),
 SITE_ID                                VARCHAR2(31),
 ANTENNA_ID                             VARCHAR2(31),
 POLARISATION                           VARCHAR2(3),
 AZIMUTH                                NUMBER,
 HEIGHT                                 NUMBER,
 TILT                                   NUMBER,
 FEEDER_LOSS                            NUMBER,
 LEVEL_OF_PROTECTION                    NUMBER,
 EIRP                                   NUMBER,
 EIRP_UNIT                              VARCHAR2(31),
 SV_ID                                  NUMBER(10),
 SS_ID                                  NUMBER(10),
 EFL_ID                                 VARCHAR2(40),
 EFL_FREQ_IDENT                         VARCHAR2(31),
 EFL_SYSTEM                             VARCHAR2(63),
 LEQD_MODE                              VARCHAR2(1),
 RECEIVER_THRESHOLD                     NUMBER,
 AREA_AREA_ID                           NUMBER(10),
 CALL_SIGN                              VARCHAR2(255),
 AREA_DESCRIPTION                       VARCHAR2(9),
 AP_ID                                  NUMBER(10),
 CLASS_OF_STATION_CODE                  VARCHAR2(31),
 SUPPLIMENTAL_FLAG                      VARCHAR2(199),
 EQ_FREQ_RANGE_MIN                      NUMBER,
 EQ_FREQ_RANGE_MAX                      NUMBER,
 NATURE_OF_SERVICE_ID                   VARCHAR2(3),
 HOURS_OF_OPERATION                     VARCHAR2(11),
 SA_ID                                  NUMBER(10),
 RELATED_EFL_ID                         NUMBER,
 EQP_ID                                 NUMBER(10),
 ANTENNA_MULTI_MODE                     VARCHAR2(3),
 POWER_IND                              VARCHAR2(14),
 LPON_CENTER_LONGITUDE                  NUMBER,
 LPON_CENTER_LATITUDE                   NUMBER,
 TCS_ID                                 NUMBER(10),
 TECH_SPEC_ID                           VARCHAR2(63),
 DROPTHROUGH_ID                         VARCHAR2(63),
 STATION_TYPE                           VARCHAR2(511),
 STATION_NAME                           VARCHAR2(63),
 FOREIGN KEY (LICENCE_NO) REFERENCES licence(LICENCE_NO),
 FOREIGN KEY (SITE_ID) REFERENCES site(SITE_ID),
 FOREIGN KEY (ANTENNA_ID) REFERENCES antenna(ANTENNA_ID),
 FOREIGN KEY (POLARISATION) REFERENCES antenna_polarity(POLARISATION_CODE),
 FOREIGN KEY (SV_ID) REFERENCES licence_service(SV_ID),
 FOREIGN KEY (SS_ID) REFERENCES licence_subservice(SS_ID),
 FOREIGN KEY (AREA_AREA_ID) REFERENCES access_area(AREA_ID),
 FOREIGN KEY (CLASS_OF_STATION_CODE) REFERENCES class_of_station(CODE),
 FOREIGN KEY (NATURE_OF_SERVICE_ID) REFERENCES nature_of_service(CODE),
 FOREIGN KEY (SA_ID) REFERENCES satellite(SA_ID)
 );
 create index ix_device_details_001 on device_details(DEVICE_REGISTRATION_IDENTIFIER);

 create table device_power_pattern(
 DPP_ID             INTEGER PRIMARY KEY AUTOINCREMENT,
 SDD_ID   				NUMBER(10),
 REGISTRATION_IDENTIFIER VARCHAR2(63),
 START_ANGLE NUMBER(10),
 STOP_ANGLE NUMBER(10),
 POWER NUMBER(10),
 FOREIGN KEY (REGISTRATION_IDENTIFIER) REFERENCES device_details(DEVICE_REGISTRATION_IDENTIFIER)
);
create index ix_device_power_pattern_001 on device_power_pattern(SDD_ID,REGISTRATION_IDENTIFIER);

create table nature_of_service(
 CODE			VARCHAR2(31) PRIMARY KEY,
 DESCRIPTION            VARCHAR2(511)
);
create index ix_nature_of_service_001 on nature_of_service(DESCRIPTION);

create table satellite(
 SA_ID			NUMBER(10) PRIMARY KEY,
 SA_SAT_NAME            VARCHAR2(31),
 SA_SAT_LONG_NOM        NUMBER,
 SA_SAT_INCEXC          NUMBER,
 SA_SAT_GEO_POS         VARCHAR2(1),
 SA_SAT_MERIT_G_T       NUMBER
);
create index ix_satellite_001 on satellite(SA_SAT_NAME;

create table site(
 SITE_ID		VARCHAR2(31) PRIMARY KEY,
 LATITUDE               NUMBER,
 LONGITUDE              NUMBER,
 NAME                   VARCHAR2(767),
 STATE                  VARCHAR2(80),
 LICENSING_AREA_ID      NUMBER,
 POSTCODE               VARCHAR2(18),
 SITE_PRECISION         VARCHAR2(31),
 ELEVATION              NUMBER,
 HCIS_L2		VARCHAR2(31)
);
create index ix_site_001 on site(NAME);

