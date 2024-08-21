using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using IBuySpy;

namespace TestProject1
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            CustomersDB customersDB = new CustomersDB();
            string login = customersDB.Login("jb@IBuySpy.com", "IBS_007");
            Assert.AreEqual(login, "1");

        }
    }
}
