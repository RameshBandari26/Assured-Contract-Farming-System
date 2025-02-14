from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities

def test_register_user():
    driver = webdriver.Chrome()
    driver.get("http://localhost:8080/MyProject/agritech/register.jsp")
    
    # Wait until the username field is present
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "username")))
    
    driver.find_element(By.NAME, "username").send_keys("test_user")
    driver.find_element(By.NAME, "email").send_keys("user@example.com")
    driver.find_element(By.NAME, "password").send_keys("password123")
    driver.find_element(By.NAME, "address").send_keys("123 Farm Lane")
    driver.find_element(By.NAME, "role").send_keys("Farmer")
    driver.find_element(By.XPATH, "//button[text()='Register']").click()
    
    # Verify registration is successful
    assert "Login" in driver.page_source
    driver.quit()

def test_login_user():
    driver = webdriver.Chrome()
    driver.get("http://localhost:8080/MyProject/agritech/login.jsp")
    
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "email")))
    
    driver.find_element(By.NAME, "email").send_keys("user@example.com")
    driver.find_element(By.NAME, "password").send_keys("password123")
    driver.find_element(By.XPATH, "//input[@value='Login']").click()
    
    # Verify login is successful
    assert "Dashboard" in driver.page_source
    driver.quit()

def test_list_crop():
    driver = webdriver.Chrome()
    driver.get("http://localhost:8080/MyProject/agritech/login.jsp")
    
    # Login first
    driver.find_element(By.NAME, "email").send_keys("user@example.com")
    driver.find_element(By.NAME, "password").send_keys("password123")
    driver.find_element(By.XPATH, "//input[@value='Login']").click()
    
    # Navigate to crop listing
    driver.get("http://localhost:8080/MyProject/agritech/dashboard.jsp")
    driver.find_element(By.XPATH, "//a[text()='List New Crop']").click()
    
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.NAME, "crop_name")))
    
    driver.find_element(By.NAME, "crop_name").send_keys("Wheat")
    driver.find_element(By.NAME, "quantity").send_keys("50")
    driver.find_element(By.NAME, "price_per_unit").send_keys("1500")
    driver.find_element(By.XPATH, "//button[text()='Submit']").click()
    
    # Verify crop listing
    assert "Wheat" in driver.page_source
    driver.quit()

if __name__ == "__main__":
    test_register_user()
    test_login_user()
    test_list_crop()
