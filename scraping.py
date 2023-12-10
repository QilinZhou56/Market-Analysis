from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup
import csv

# URL of the page
url = "https://www.zhihu.com/tardis/zm/art/269501526?source_id=1003"

# Set up the Selenium driver
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))

# Load the page
driver.get(url)

# Wait for the dynamic content to load
driver.implicitly_wait(10)

# Get the page source
html = driver.page_source
driver.quit()

# Parse the HTML with Beautiful Soup
soup = BeautifulSoup(html, "html.parser")

# Prepare a list to store data
coffee_machines = []
current_machine = {"种类": "", "优点": "", "缺点": ""}

# Find the header
header = soup.find(lambda tag: tag.name == "h2" and
                    "各类咖啡机的原理和特点" in tag.text)

if header:

    # Start from the header and move to subsequent siblings
    for sibling in header.find_next_siblings():
        text = sibling.get_text()
        if sibling.name == "h2":
            # Stop if we reach another header
            break
        for bold_tag in sibling.find_all("b"):
            bold_text = bold_tag.get_text().strip()
            if any(char.isdigit() for char in bold_text):
                if current_machine["种类"]:
                    coffee_machines.append(current_machine)
                    current_machine = {"种类": "", "优点": "", "缺点":""}
                current_machine["种类"] = bold_text

        if "优点" in text:
            current_machine["优点"] = text.split("优点")[-1].strip(" ： ")
        if "缺点" in text:
            current_machine["缺点"] = text.split("缺点")[-1].strip(" ： ")

    # Add the last machine to the list
    if current_machine["种类"]:
        coffee_machines.append(current_machine)

else:
    print("Header not found.")

# Write data to CSV file
csv_file = "coffee_machines.csv"
with open(csv_file, mode="w", newline="", encoding="utf-8-sig") as file:
    writer = csv.DictWriter(file, fieldnames=["种类", "优点", "缺点"])
    writer.writeheader()
    writer.writerows(coffee_machines)