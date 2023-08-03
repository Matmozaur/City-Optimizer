import requests
import os

from sqlalchemy import Column, Integer, String, Float, ForeignKey, create_engine
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import declarative_base, relationship, sessionmaker

POSTGRES_USER = os.environ.get('POSTGRES_USER')
POSTGRES_PASSWORD = os.environ.get('POSTGRES_PASSWORD')
POSTGRES_DB = os.environ.get('POSTGRES_DB')

Base = declarative_base()


class Language(Base):
    __tablename__ = 'language'
    language_id = Column(Integer, primary_key=True)
    language_name = Column(String(100), nullable=False, unique=True)

    countries = relationship('Country', back_populates='language')


class Country(Base):
    __tablename__ = 'country'
    country_id = Column(Integer, primary_key=True)
    country_name = Column(String(100), nullable=False, unique=True)
    country_code = Column(String(10), nullable=False, unique=True)
    population = Column(Integer)
    language_id = Column(Integer, ForeignKey('language.language_id'))
    crime_rate = Column(Float(precision=2))

    language = relationship('Language', back_populates='countries')


def populate_language_and_country():
    engine = create_engine(f'postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@postgres_db:5432/{POSTGRES_DB}')
    Session = sessionmaker(bind=engine)

    response = requests.get('https://restcountries.com/v3.1/region/europe')
    session = Session()
    languages = [Language(language_name=lang) for lang in set.union(*[set(r['languages'].values()) for r in response.json()])]
    session.bulk_save_objects(languages)
    session.commit()
    languages_dict = {lang.language_name: lang.language_id for lang in session.query(Language).all()}

    countries = [Country(country_name=c['name']['common'],
                         country_code=c['cca2'],
                         population=c['population'],
                         language_id=languages_dict.get(list(c['languages'].values())[0]),
                         ) for c in response.json() if c['area'] > 0]

    session.bulk_save_objects(countries)
    session.commit()
    session.close()


if __name__ == '__main__':
    try:
        populate_language_and_country()
    except IntegrityError:
        pass
