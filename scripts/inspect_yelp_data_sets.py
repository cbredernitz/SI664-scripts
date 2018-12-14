import logging
import os
import ast
import pandas as pd
from pandas.io.json import json_normalize
import sys as sys
import json
import numpy as np

def main(argv=None):
	"""
	Utilize Pandas library to read in both UNSD M49 country and area .csv file
	(tab delimited) as well as the UNESCO heritage site .csv file (tab delimited).
	Extract regions, sub-regions, intermediate regions, country and areas, and
	other column data.  Filter out duplicate values and NaN values and sort the
	series in alphabetical order. Write out each series to a .csv file for inspection.
	"""
	if argv is None:
		argv = sys.argv

	msg = [
		'Source file read {0}',
		'UNSD M49 regions written to file {0}',
		'UNSD M49 sub-regions written to file {0}',
		'UNSD M49 intermediate regions written to file {0}',
		'UNSD M49 countries and areas written to file {0}',
		'UNSD M49 development status written to file {0}',
		'UNESCO heritage site countries/areas written to file {0}',
		'UNESCO heritage site categories written to file {0}',
		'UNESCO heritage site regions written to file {0}',
		'UNESCO heritage site transboundary values written to file {0}'
	]

	# Creating small sample of data:
	business_json = './input/json/yelp_academic_dataset_business.json'
	business_df = pd.read_json(business_json, lines=True, encoding='utf8')

	user_df = pd.read_csv('input/csv/yelp_user.csv')
	user_df_small = user_df.iloc[:1000]
	user_df_small.to_csv('SMALL_yelp_user.csv', quotechar='"', index=False)

	review_df = pd.read_csv('input/csv/yelp_review.csv')
	review_df_small = review_df.iloc[:5000]
	review_df_small.to_csv('SMALL_yelp_review.csv', quotechar='"', index=False)
	# Setting logging format and default level
	logging.basicConfig(format='%(levelname)s: %(message)s', level=logging.DEBUG)

	# Read in United Nations Statistical Division (UNSD) M49 Standard data set (tabbed separator)


	# # logging.info(msg[0].format(os.path.abspath(business_df)))

	# # # Write categories to a .csv file.
	# categories = []
	# for x in business_df['categories']:
	# 	if x != None:
	# 		cat = x.split(',')
	# 		for each in cat:
	# 			if each.strip() not in categories:
	# 				categories.append(each.strip())

	# # business_cat = extract_filtered_series(df, 'categories')
	# business_cat_csv = './output/business_categories.csv'
	# write_series_to_csv(pd.Series(categories), business_cat_csv, '\t', False)
	
	# # # Write cities to a .csv file.
	# cities = []
	# for x in business_df['city']:
	# 	if x != None:
	# 		if x.strip() not in cities:
	# 			cities.append(x.strip())

	# cities_csv = './output/cities.csv'
	# write_series_to_csv(pd.Series(cities), cities_csv, '\t', False)
	# # logging.info(msg[2].format(os.path.abspath(unsd_sub_region_csv)))

	# # # Write states to a .csv file.
	# states = []
	# for x in business_df['state']:
	# 	if x != None:
	# 		if x.strip() not in states:
	# 			states.append(x.strip())

	# states_csv = './output/states.csv'
	# write_series_to_csv(pd.Series(states), states_csv, '\t', False)
	
	# # # Write attire to a .csv file.
	# attires = []
	# for x in df['RestaurantsAttire']:
	# 	if x != None:
	# 		if x not in attires:
	# 			attires.append(x)

	# attires_csv = './output/attires.csv'
	# write_series_to_csv(pd.Series(attires), attires_csv, '\t', False)
	
	# # # Write noise status to a .csv file.
	# noise = []
	# for x in df['NoiseLevel']:
	# 	if x != None:
	# 		if x not in noise:
	# 			noise.append(x)

	# noise_csv = './output/noise.csv'
	# write_series_to_csv(pd.Series(noise), noise_csv, '\t', False)

	## Creating full clean business csv
	attributes_df = business_df[['business_id','attributes']]
	attire = []
	noise = []
	for val in attributes_df['attributes']:
		try:
			attire.append(val['RestaurantsAttire'])
		except:
			attire.append("")
		try:
			noise.append(val['NoiseLevel'])
		except:
			noise.append("")
	attributes_df['Attire'] = pd.Series(attire)
	attributes_df['Noise'] = pd.Series(noise)
	attributes_df = attributes_df.drop('attributes', axis=1)

	businesses = pd.read_csv('./input/csv/yelp_business.csv')
	full_data = pd.merge(businesses, attributes_df, how='inner', on='business_id')
	for col in full_data.columns:
		full_data[col] = full_data[col].fillna('Null').astype(str)
		full_data[col] = full_data[col].apply(lambda x: x.strip('""""'))
	full_data_small = full_data.iloc[:1000]
	full_data_small.to_csv('SMALL_yelp_full_businesses.csv', quotechar='"', index=False)

def extract_filtered_series(data_frame, column_name):
	"""
	Returns a filtered Panda Series one-dimensional ndarray from a targeted column.
	Duplicate values and NaN or blank values are dropped from the result set which is
	returned sorted (ascending).
	:param data_frame: Pandas DataFrame
	:param column_name: column name string
	:return: Panda Series one-dimensional ndarray
	"""
	return data_frame[column_name].drop_duplicates().dropna().sort_values()


def pandas_(s, lookup):
	df = pd.DataFrame()
	for each in s:
		 if each == None:
			 pass
		 else:
			 print(each)
			 # for value in each:
				 # if value == lookup:
					 # print(value)
					 # df.append(value)
	# return df

def write_series_to_csv(series, path, delimiter=',', row_name=True):
	"""
	Write Pandas DataFrame to a *.csv file.
	:param series: Pandas one dimensional ndarray
	:param path: file path
	:param delimiter: field delimiter
	:param row_name: include row name boolean
	"""
	series.to_csv(path, sep=delimiter, index=row_name)


if __name__ == '__main__':
	sys.exit(main())
