import sqlite3
import csv
import click
from flask import current_app, g


def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect(
            current_app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
        )
        g.db.row_factory = sqlite3.Row

    return g.db


def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()


def import_db():
    read_fee_status(input_file='data/fee_status.csv')
    read_client_type(input_file='data/client_type.csv')
    read_industry_cat(input_file='data/industry_cat.csv')
    read_class_of_station(input_file='data/class_of_station.csv')
    read_nature_of_service(input_file='data/nature_of_service.csv')
    read_bsl_area(input_file='data/bsl_area.csv')
    read_bsl(input_file='data/bsl.csv')
    read_licence_service(input_file='data/licence_service.csv')
    read_licence_subservice(input_file='data/licence_subservice.csv')
    read_licence_status(input_file='data/licence_status.csv')
    read_licensing_area(input_file='data/licensing_area.csv')
    read_licence(input_file='data/licence.csv')
    read_access_area(input_file='data/access_area.csv')
    read_antenna(input_file='data/antenna.csv')
    read_antenna_pattern(input_file='data/antenna_pattern.csv')
    read_antenna_polarity(input_file='data/antenna_polarity.csv')
    read_client(input_file='data/client.csv')
    read_applic_text_block(input_file='data/applic_text_block.csv')
    read_reports_text_block(input_file='data/reports_text_block.csv')
    read_auth_spectrum_area(input_file='data/auth_spectrum_area.csv')
    read_auth_spectrum_freq(input_file='data/auth_spectrum_freq.csv')
    read_site(input_file='data/site.csv')
    read_satellite(input_file='data/satellite.csv')
    read_device_details(input_file='data/device_details.csv')
    read_device_power_pattern(input_file='data/LICENCE_.csv')


def init_db():
    db = get_db()

    with current_app.open_resource('schema.sql') as f:
        db.executescript(f.read().decode('utf8'))


@click.command('init-db')
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')


@click.command('load-db')
def load_db_command():
    import_db()
    click.echo('Finish loading database')


def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)
    app.cli.add_command(load_db_command)


def read_access_area(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got access_area')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT AREA_ID FROM access_area WHERE AREA_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO access_area(AREA_ID,AREA_CODE,AREA_NAME,AREA_CATEGORY) VALUES(?,?,?,?)',
                           (row[0], row[1], row[2], row[3]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_antenna(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got antenna')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_antenna(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT ANTENNA_ID FROM antenna WHERE ANTENNA_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute(
                    'INSERT INTO antenna(ANTENNA_ID,GAIN,FRONT_TO_BACK,H_BEAMWIDTH,V_BEAMWIDTH,BAND_MIN_FREQ,BAND_MIN_FREQ_UNIT,BAND_MAX_FREQ,BAND_MAX_FREQ_UNIT,ANTENNA_SIZE,ANTENNA_TYPE,MODEL,MANUFACTURER) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)',
                    (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11],
                     row[11]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_antenna_pattern(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got antenna_pattern')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_antenna_pattern(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute(
                'SELECT AP_ID FROM antenna_pattern WHERE ANTENNA_ID=? AND AZ_TYPE=? AND ANGLE_REF=? AND ANGLE=? AND ATTENUATION=?',
                (row[0], row[1], row[2], row[3], row[4])).fetchone()
            if result is None:
                db.execute(
                    'INSERT INTO antenna_pattern(ANTENNA_ID,AZ_TYPE,ANGLE_REF,ANGLE,ATTENUATION) VALUES(?,?,?,?,?)',
                    (row[0], row[1], row[2], row[3], row[4]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_antenna_polarity(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got antenna_polarity')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT POLARISATION_CODE FROM antenna_polarity WHERE POLARISATION_CODE=?',
                                (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO antenna_polarity(POLARISATION_CODE,POLARISATION_TEXT) VALUES(?,?)',
                           (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_applic_text_block(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got applic_text_block')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_applic_text_block(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT APTB_ID FROM applic_text_block WHERE APTB_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO applic_text_block(APTB_ID,APTB_TABLE_PREFIX,APTB_TABLE_ID,LICENCE_NO,APTB_DESCRIPTION,APTB_CATEGORY,APTB_TEXT,APTB_ITEM) VALUES(?,?,?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_auth_spectrum_area(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got auth_spectrum_area')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_auth_spectrum_area(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute(
                'SELECT ASA_ID FROM auth_spectrum_area WHERE LICENCE_NO=? AND AREA_CODE=? AND AREA_NAME=? AND AREA_DESCRIPTION=?',
                (row[0], row[1], row[2], row[3])).fetchone()
            if result is None:
                db.execute(
                    'INSERT INTO auth_spectrum_area(LICENCE_NO,AREA_CODE,AREA_NAME,AREA_DESCRIPTION) VALUES(?,?,?,?)',
                    (row[0], row[1], row[2], row[3]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_auth_spectrum_freq(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got auth_spectrum_freq')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_auth_spectrum_freq(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT ASF_ID FROM auth_spectrum_freq WHERE LICENCE_NO=? AND AREA_CODE=? AND AREA_NAME=? AND LW_FREQUENCY_START=? AND LW_FREQUENCY_END=? AND UP_FREQUENCY_START=? AND UP_FREQUENCY_END=?', (row[0], row[1], row[2], row[3], row[4], row[5], row[6])).fetchone()
            if result is None:
                db.execute(
                    'INSERT INTO auth_spectrum_freq(LICENCE_NO,AREA_CODE,AREA_NAME,LW_FREQUENCY_START,LW_FREQUENCY_END,UP_FREQUENCY_START,UP_FREQUENCY_END) VALUES(?,?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5], row[6]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_bsl_area(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got bsl_area')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT AREA_CODE FROM bsl_area WHERE AREA_CODE=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO bsl_area(AREA_CODE,AREA_NAME) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_bsl(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got bsl')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_bsl(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT BSL_NO FROM bsl WHERE BSL_NO=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO bsl(BSL_NO,MEDIUM_CATEGORY,REGION_CATEGORY,COMMUNITY_INTEREST,BSL_STATE,DATE_COMMENCED,ON_AIR_ID,CALL_SIGN,IBL_TARGET_AREA,AREA_CODE,REFERENCE) VALUES(?,?,?,?,?,?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_class_of_station(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got class_of_station')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT CODE FROM class_of_station WHERE CODE=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO class_of_station(CODE,DESCRIPTION) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_client(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got client')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_client(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute(
                'SELECT CLIENT_NO FROM client WHERE CLIENT_NO=?', (row[0],)).fetchone()
            if result is None:
                db.execute(
                    'INSERT INTO client(CLIENT_NO,LICENCEE,TRADING_NAME,ACN,ABN,POSTAL_STREET,POSTAL_SUBURB,POSTAL_STATE,POSTAL_POSTCODE,CAT_ID,CLIENT_TYPE_ID,FEE_STATUS_ID) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_client_type(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got client_type')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT TYPE_ID FROM client_type WHERE TYPE_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO client_type(TYPE_ID,NAME) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_device_details(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got device_details')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_device_details(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT SDD_ID FROM device_details WHERE SDD_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO device_details(SDD_ID,LICENCE_NO,DEVICE_REGISTRATION_IDENTIFIER,'
                           'FORMER_DEVICE_IDENTIFIER,AUTHORISATION_DATE,CERTIFICATION_METHOD,GROUP_FLAG,SITE_RADIUS,'
                           'FREQUENCY,BANDWIDTH,CARRIER_FREQ,EMISSION,DEVICE_TYPE,TRANSMITTER_POWER,'
                           'TRANSMITTER_POWER_UNIT,SITE_ID,ANTENNA_ID,POLARISATION,AZIMUTH,HEIGHT,TILT,FEEDER_LOSS,'
                           'LEVEL_OF_PROTECTION,EIRP,EIRP_UNIT,SV_ID,SS_ID,EFL_ID,EFL_FREQ_IDENT,EFL_SYSTEM,'
                           'LEQD_MODE,RECEIVER_THRESHOLD,AREA_AREA_ID,CALL_SIGN,AREA_DESCRIPTION,AP_ID,'
                           'CLASS_OF_STATION_CODE,SUPPLIMENTAL_FLAG,EQ_FREQ_RANGE_MIN,EQ_FREQ_RANGE_MAX,'
                           'NATURE_OF_SERVICE_ID,HOURS_OF_OPERATION,SA_ID,RELATED_EFL_ID,EQP_ID,ANTENNA_MULTI_MODE,'
                           'POWER_IND,LPON_CENTER_LONGITUDE,LPON_CENTER_LATITUDE,TCS_ID,TECH_SPEC_ID,DROPTHROUGH_ID,'
                           'STATION_TYPE,STATION_NAME) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'
                           '?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)',
                           (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10],
                            row[11], row[12], row[13], row[14], row[15], row[16], row[17], row[18], row[19], row[20],
                            row[21], row[22], row[23], row[24], row[25], row[26], row[27], row[28], row[29], row[30],
                            row[31], row[32], row[33], row[34], row[35], row[36], row[37], row[38], row[39], row[40],
                            row[41], row[42], row[43], row[44], row[45], row[46], row[47], row[48], row[49], row[50],
                            row[51], row[52], row[53]))
                r_ins = r_ins + 1
                if r_ins % 1000 == 0:
                    db.commit()
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_device_power_pattern(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got device_power_pattern')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_device_power_pattern(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT DPP_ID FROM device_power_pattern WHERE SDD_ID=? AND REGISTRATION_IDENTIFIER=? AND START_ANGLE=? AND STOP_ANGLE=? AND POWER=?', (row[0], row[1], row[2], row[3], row[4])).fetchone()
            if result is None:
                db.execute('INSERT INTO device_power_pattern(SDD_ID,REGISTRATION_IDENTIFIER,START_ANGLE,STOP_ANGLE,POWER) VALUES(?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4]))
                r_ins = r_ins + 1
            if r_ins % 1000 == 0:
                db.commit()
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_fee_status(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got fee_status')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT FEE_STATUS_ID FROM fee_status WHERE FEE_STATUS_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO fee_status(FEE_STATUS_ID,FEE_STATUS_TEXT) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_industry_cat(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got industry_cat')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT CAT_ID FROM industry_cat WHERE CAT_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO industry_cat(CAT_ID,DESCRIPTION,NAME) VALUES(?,?,?)', (row[0], row[1], row[2]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_licence_service(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got licence_service')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT SV_ID FROM licence_service WHERE SV_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO licence_service(SV_ID,SV_NAME) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_licence_status(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got licence_service')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT STATUS FROM licence_status WHERE STATUS=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO licence_status(STATUS,STATUS_TEXT) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_licence_subservice(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got licence_subservice')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT SS_ID FROM licence_subservice WHERE SS_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO licence_subservice(SS_ID,SV_SV_ID,SS_NAME) VALUES(?,?,?)', (row[0], row[1], row[2]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_licensing_area(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got licensing_area')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT LICENSING_AREA_ID FROM licensing_area WHERE LICENSING_AREA_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO licensing_area(LICENSING_AREA_ID,DESCRIPTION) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_licence(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got licence')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT LICENCE_NO FROM licence WHERE LICENCE_NO=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO licence(LICENCE_NO,CLIENT_NO,SV_ID,SS_ID,LICENCE_TYPE_NAME,LICENCE_CATEGORY_NAME,DATE_ISSUED,DATE_OF_EFFECT,DATE_OF_EXPIRY,STATUS,STATUS_TEXT,AP_ID,AP_PRJ_IDENT,SHIP_NAME,BSL_NO) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12], row[13], row[14]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_nature_of_service(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got nature_of_service')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            r_read = r_read + 1
            result = db.execute('SELECT CODE FROM nature_of_service WHERE CODE=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO nature_of_service(CODE,DESCRIPTION) VALUES(?,?)', (row[0], row[1]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_reports_text_block(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got reports_text_block')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_reports_text_block(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT RTB_ID FROM reports_text_block WHERE RTB_ITEM=? AND RTB_CATEGORY=? AND RTB_DESCRIPTION=? AND RTB_START_DATE=? AND RTB_END_DATE=? AND RTB_TEXT=?', (row[0], row[1], row[2], row[3], row[4], row[5])).fetchone()
            if result is None:
                db.execute('INSERT INTO reports_text_block(RTB_ITEM,RTB_CATEGORY,RTB_DESCRIPTION,RTB_START_DATE,RTB_END_DATE,RTB_TEXT) VALUES(?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_satellite(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got site')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_satellite(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT SA_ID FROM satellite WHERE SA_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO satellite(SA_ID,SA_SAT_NAME,SA_SAT_LONG_NOM,SA_SAT_INCEXC,SA_SAT_GEO_POS,SA_SAT_MERIT_G_T) VALUES(?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))


def read_site(input_file=None):
    r_read = 0
    r_ins = 0
    db = get_db()
    with open('{0}'.format(input_file)) as csvfile:
        print('Got site')
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            if r_read % 1000 == 0:
                print('read_site(): {0}/{1}'.format(r_read, r_ins))
            r_read = r_read + 1
            result = db.execute('SELECT SITE_ID FROM site WHERE SITE_ID=?', (row[0],)).fetchone()
            if result is None:
                db.execute('INSERT INTO site(SITE_ID,LATITUDE,LONGITUDE,NAME,STATE,LICENSING_AREA_ID,POSTCODE,SITE_PRECISION,ELEVATION,HCIS_L2) VALUES(?,?,?,?,?,?,?,?,?,?)', (row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9]))
                r_ins = r_ins + 1
        db.commit()
    print('Rows Read: {0}, Inserted: {1}'.format(r_read, r_ins))
