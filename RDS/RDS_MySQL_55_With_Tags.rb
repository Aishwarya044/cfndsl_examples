CloudFormation do
  Description("AWS CloudFormation Sample Template RDS_MySQL_55_With_Tags: Sample template showing how to create an RDS DBInstance version 5.5 with tags and alarming on important metrics that indicate the health of the database **WARNING** This template creates an Amazon Relational Database Service database instance and Amazon CloudWatch alarms. You will be billed for the AWS resources used if you create a stack from this template.")
  AWSTemplateFormatVersion("2010-09-09")

  Parameter("DBName") do
    Description("The database name")
    Type("String")
    Default("MyDatabase")
    AllowedPattern("[a-zA-Z][a-zA-Z0-9]*")
    MaxLength(64)
    MinLength(1)
    ConstraintDescription("must begin with a letter and contain only alphanumeric characters.")
  end

  Parameter("DBUser") do
    Description("The database admin account username")
    Type("String")
    AllowedPattern("[a-zA-Z][a-zA-Z0-9]*")
    NoEcho(true)
    MaxLength(16)
    MinLength(1)
    ConstraintDescription("must begin with a letter and contain only alphanumeric characters.")
  end

  Parameter("DBPassword") do
    Description("The database admin account password")
    Type("String")
    AllowedPattern("[a-zA-Z0-9]*")
    NoEcho(true)
    MaxLength(41)
    MinLength(8)
    ConstraintDescription("must contain only alphanumeric characters.")
  end

  Parameter("DBAllocatedStorage") do
    Description("The size of the database (Gb)")
    Type("Number")
    Default("5")
    MaxValue(1024)
    MinValue(5)
    ConstraintDescription("must be between 5 and 1024Gb.")
  end

  Parameter("DBInstanceClass") do
    Description("The database instance type")
    Type("String")
    Default("db.m1.small")
    AllowedValues([
  "db.m1.small",
  "db.m1.large",
  "db.m1.xlarge",
  "db.m2.xlarge",
  "db.m2.2xlarge",
  "db.m2.4xlarge"
])
    ConstraintDescription("must select a valid database instance type.")
  end

  Mapping("InstanceTypeMap", {
  "db.m1.large"   => {
    "CPULimit"              => "60",
    "FreeStorageSpaceLimit" => "1024",
    "ReadIOPSLimit"         => "100",
    "WriteIOPSLimit"        => "100"
  },
  "db.m1.small"   => {
    "CPULimit"              => "60",
    "FreeStorageSpaceLimit" => "1024",
    "ReadIOPSLimit"         => "100",
    "WriteIOPSLimit"        => "100"
  },
  "db.m1.xlarge"  => {
    "CPULimit"              => "60",
    "FreeStorageSpaceLimit" => "1024",
    "ReadIOPSLimit"         => "100",
    "WriteIOPSLimit"        => "100"
  },
  "db.m2.2xlarge" => {
    "CPULimit"              => "60",
    "FreeStorageSpaceLimit" => "1024",
    "ReadIOPSLimit"         => "100",
    "WriteIOPSLimit"        => "100"
  },
  "db.m2.4xlarge" => {
    "CPULimit"              => "60",
    "FreeStorageSpaceLimit" => "1024",
    "ReadIOPSLimit"         => "100",
    "WriteIOPSLimit"        => "100"
  },
  "db.m2.xlarge"  => {
    "CPULimit"              => "60",
    "FreeStorageSpaceLimit" => "1024",
    "ReadIOPSLimit"         => "100",
    "WriteIOPSLimit"        => "100"
  }
})

  Resource("MyDB") do
    Type("AWS::RDS::DBInstance")
    DeletionPolicy("Snapshot")
    Property("DBName", Ref("DBName"))
    Property("AllocatedStorage", Ref("DBAllocatedStorage"))
    Property("DBInstanceClass", Ref("DBInstanceClass"))
    Property("Engine", "MySQL")
    Property("EngineVersion", "5.5")
    Property("MasterUsername", Ref("DBUser"))
    Property("MasterUserPassword", Ref("DBPassword"))
    Property("Tags", [
  {
    "Key"   => "Name",
    "Value" => "My SQL Database"
  }
])
  end

  Output("JDBCConnectionString") do
    Description("JDBC connection string for database")
    Value(FnJoin("", [
  "jdbc:mysql://",
  FnGetAtt("MyDB", "Endpoint.Address"),
  ":",
  FnGetAtt("MyDB", "Endpoint.Port"),
  "/",
  Ref("DBName")
]))
  end

  Output("DBAddress") do
    Description("Address of database endpoint")
    Value(FnGetAtt("MyDB", "Endpoint.Address"))
  end

  Output("DBPort") do
    Description("Database endpoint port number")
    Value(FnGetAtt("MyDB", "Endpoint.Port"))
  end
end
