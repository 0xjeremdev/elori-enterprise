import os
import time
import typing
import unittest

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.remote.webdriver import WebDriver
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait

BASE_URL = "http://localhost:3000"

class ElroiLiteTest(unittest.TestCase):
    driver: WebDriver
    wait: WebDriverWait

    #@classmethod
    #def setUpClass(cls):
        # TODO: Reset database?
        # TODO: Start backend/frontend service
        # TODO: Register new user?

    #@classmethod
    #def tearDownClass(cls):
        

    def setUp(self):
        self.driver = webdriver.Chrome() # TODO: Consider headless Chrome
        self.wait = WebDriverWait(self.driver, 10)

    def tearDown(self):
        self.driver.close()

    def test_browse_to_page(self):        
        self.driver.get(BASE_URL)

        # TODO: Handle if we may be logged in already
        # TODO: Handle if there is a "session ended" notification
        emailInput: WebElement = self.wait.until(EC.presence_of_element_located((By.XPATH, "//input[@placeholder='Your E-Mail']")))
        
        emailInput.send_keys("test@elroi.ai")

        passwordInput: WebElement = self.driver.find_element_by_xpath("//input[@type='password']")

        if passwordInput is None:
            # Could be logged in already?
            # Could be at "session ended" notification
            raise Exception("No password box found.")
        
        passwordInput.send_keys("Test12345!")

        self.driver.find_element_by_css_selector("button.ui.button.login").click()


    
if __name__ == "__main__":
    unittest.main()
