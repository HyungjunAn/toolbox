import sys
from selenium import webdriver

options = webdriver.ChromeOptions()
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

driver = webdriver.Chrome(options=options)
driver.get(sys.argv[1])

print('--------------------------------------------------------------')
for e in driver.find_elements('id', 'video-title'): 
    title = e.get_attribute('title')
    href = e.get_attribute('href')
    print(f'1. [{title}]({href})')
print('--------------------------------------------------------------')
