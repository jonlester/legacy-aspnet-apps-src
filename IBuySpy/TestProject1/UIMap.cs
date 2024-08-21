namespace TestProject1
{
    using System;
    using System.Collections.Generic;
    using System.Drawing;
    using System.Windows.Input;
    using System.CodeDom.Compiler;
    using System.Text.RegularExpressions;
    using Microsoft.VisualStudio.TestTools.UITest.Extension;
    using Microsoft.VisualStudio.TestTools.UITesting;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using Keyboard = Microsoft.VisualStudio.TestTools.UITesting.Keyboard;
    using Mouse = Microsoft.VisualStudio.TestTools.UITesting.Mouse;
    using MouseButtons = System.Windows.Forms.MouseButtons;
    
    
    public partial class UIMap
    {
        public void VerifyTotalEqualsSubTotal()
        {
            #region Variable Declarations
            HtmlSpan item49990Pane = this.Httpmathewanweb5StorWindow.Httpmathewanweb5StorClient.Httpmathewanweb5StorDocument2.Item49990Pane;
            HtmlCell item49990Cell = this.Httpmathewanweb5StorWindow.Httpmathewanweb5StorClient.Httpmathewanweb5StorDocument2.MyListTable.Item49990Cell;
            #endregion

            // Verify that total is equal to sub-total
            Assert.AreEqual(item49990Pane.InnerText, item49990Cell.InnerText);
        }

    }
}
