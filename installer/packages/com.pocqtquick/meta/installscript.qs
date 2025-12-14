function Component()
{
    // Default constructor
}

Component.prototype.createOperations = function()
{
    // Call the standard installation operations (copying files)
    component.createOperations();

    if (systemInfo.productType === "windows") {
        // Create Start Menu Shortcut
        component.addOperation("CreateShortcut", 
                               "@TargetDir@/counter_app.exe", 
                               "@StartMenuDir@/counter_app.lnk",
                               "workingDirectory=@TargetDir@");

        // Create Desktop Shortcut
        component.addOperation("CreateShortcut", 
                               "@TargetDir@/counter_app.exe", 
                               "@DesktopDir@/counter_app.lnk",
                               "workingDirectory=@TargetDir@");
    }
}