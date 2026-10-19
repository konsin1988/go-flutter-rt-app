import os
import pandas as pd
from fast_bitrix24 import Bitrix
from sqlalchemy import create_engine, text

def migrate_data():
    # 1. Load environment variables
    webhook = os.getenv("BITRIX_HOOK")
    db_link = os.getenv("DB_LINK")
    
    if not webhook or not db_link:
        raise ValueError("Missing BITRIX_HOOK or DB_LINK environment variables.")

    print("Connecting to Bitrix24...")
    bx24 = Bitrix(webhook)

    # 2. Fetch data from Bitrix (Synchronous calls)
    print("Fetching users and departments...")
    user_data = bx24.get_all('user.get', params={"filter": {"ACTIVE": True}})
    dept_data = bx24.get_all('department.get', {})

    # 3. Process Departments
    print("Processing department data...")
    dept_df = pd.json_normalize(dept_data)[['ID', 'NAME', 'PARENT', 'UF_HEAD']]
    dept_df.columns = ['id', 'name', 'parent', 'head']
    
    # Clean data types
    dept_df['id'] = dept_df['id'].astype('int64')
    dept_df['parent'] = dept_df['parent'].astype('Int64')
    dept_df['head'] = dept_df['head'].astype('Int64')

    # 4. Process Users
    print("Processing user data...")
    user_df = pd.json_normalize(user_data)[['ID', 'NAME', 'LAST_NAME', 'SECOND_NAME', 
                                            'EMAIL', 'PERSONAL_BIRTHDAY', 'PERSONAL_PHOTO', 
                                            'PERSONAL_MOBILE', 'WORK_POSITION', 'UF_DEPARTMENT', 
                                            'UF_PHONE_INNER']]
    user_df.columns = ['id', 'first_name', 'last_name', 'second_name', 'email', 
                       'birthday', 'photo', 'mobile', 'position', 'dept', 'phone_inner']
    
    user_df['id'] = user_df['id'].astype('int64')
    user_df['birthday'] = pd.to_datetime(user_df['birthday'], errors='coerce', utc=True)
    user_df['phone_inner'] = user_df['phone_inner'].astype('Int64')
    
    user_df['dept'] = user_df['dept'].apply(lambda x: str(x) if isinstance(x, list) else x)

    # 5. Connect and upload to PostgreSQL
    print("Connecting to PostgreSQL...")
    engine = create_engine(db_link)
    
    with engine.begin() as connection:
        print("Uploading data to staging tables...")
        
        # 1. Create temporary staging tables matching the data structure
        dept_df.to_sql('staging_b_department', con=connection, schema='user_data', if_exists='replace', index=False)
        user_df.to_sql('staging_b_user', con=connection, schema='user_data', if_exists='replace', index=False)


        print("Removing users in DB that no longer exist in Bitrix...")
        connection.execute(text("""
            DELETE FROM user_data.b_user 
            WHERE id NOT IN (SELECT id FROM user_data.staging_b_user);
        """))
        
        print("Upserting Department data...")
        # 2. Upsert Departments (assumes 'id' is the Primary Key)
        connection.execute(text("""
            INSERT INTO user_data.b_department (id, name, parent, head)
            SELECT id, name, parent, head FROM user_data.staging_b_department
            ON CONFLICT (id) DO UPDATE SET
                name = EXCLUDED.name,
                parent = EXCLUDED.parent,
                head = EXCLUDED.head;
        """))
        
        print("Upserting User data...")
        # 3. Upsert Users (assumes 'id' is the Primary Key)
        connection.execute(text("""
            INSERT INTO user_data.b_user (id, first_name, last_name, second_name, email, birthday, photo, mobile, position, dept, phone_inner)
            SELECT id, first_name, last_name, second_name, email, birthday, photo, mobile, position, dept, phone_inner FROM user_data.staging_b_user
            ON CONFLICT (id) DO UPDATE SET
                first_name = EXCLUDED.first_name,
                last_name = EXCLUDED.last_name,
                second_name = EXCLUDED.second_name,
                email = EXCLUDED.email,
                birthday = EXCLUDED.birthday,
                photo = EXCLUDED.photo,
                mobile = EXCLUDED.mobile,
                position = EXCLUDED.position,
                dept = EXCLUDED.dept,
                phone_inner = EXCLUDED.phone_inner;
        """))
        
        # 4. Clean up staging tables
        print("Cleaning up staging tables...")
        connection.execute(text("DROP TABLE IF EXISTS user_data.staging_b_department;"))
        connection.execute(text("DROP TABLE IF EXISTS user_data.staging_b_user;"))

    print("Migration upsert completed successfully!")

    #with engine.begin() as connection:
    #    # Truncate tables to safely delete old entries without dropping table schemas/indexes
    #    print("Truncating existing data...")
    #    connection.execute(text("TRUNCATE TABLE user_data.b_department RESTART IDENTITY CASCADE;"))
    #    connection.execute(text("TRUNCATE TABLE user_data.b_user RESTART IDENTITY CASCADE;"))
    #    
    #    # Append clean new data into the existing tables
    #    print("Writing new data to database...")
    #    dept_df.to_sql('b_department', con=connection, schema='user_data', if_exists='append', index=False)
    #    user_df.to_sql('b_user', con=connection, schema='user_data', if_exists='append', index=False)

    #print("Migration completed successfully!")

if __name__ == "__main__":
    migrate_data()
