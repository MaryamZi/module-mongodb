// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

///////////////////////////////
// MongoDB Client Endpoint
///////////////////////////////

import ballerinax/java;

///////////////////////////////
// MongoDB Client Endpoint
///////////////////////////////

# Represents MongoDB client endpoint.
public type Client client object {
    private ClientEndpointConfig clientEndpointConfig;

    handle datasource;

    # Gets called when the endpoint is being initialized during the package initialization.
    public function __init(ClientEndpointConfig config) returns error? {
        self.datasource = initClient(config);
    }

    public remote function insert(string collectionName, json? queryString) returns error? {
        string jsonString = queryString.toJsonString();
        return insertData(self.datasource, java:fromString(collectionName), java:fromString(jsonString));
    }

    public remote function find(string collectionName, json? queryString) returns json[] {
        if (queryString is ()) {
            return queryData(self.datasource, java:fromString(collectionName), ());
        }
        string jsonString = queryString.toJsonString();
        return queryData(self.datasource, java:fromString(collectionName), java:fromString(jsonString));
    }

    public remote function findOne(string collectionName, json? queryString) returns json {
        if (queryString is ()) {
            return queryOne(self.datasource, java:fromString(collectionName), ());
        }
        string jsonString = queryString.toJsonString();
        json jsonValue = queryOne(self.datasource, java:fromString(collectionName), java:fromString(jsonString)).
                                                                                                      toJsonString();
        return jsonValue;
    }

    public remote function replace(string collectionName, json? filter, json? replacement, boolean upsert) returns int {
        string jsonStringFilter = filter.toJsonString();
        string jsonStringReplacement = replacement.toJsonString();
        return replaceData(self.datasource, java:fromString(collectionName), java:fromString(jsonStringFilter),
                                                                      java:fromString(jsonStringReplacement), upsert);
    }

    public remote function delete(string collectionName, json? filter, boolean isMultiple) returns int {
        string jsonStringFilter = filter.toJsonString();
        return deleteData(self.datasource, java:fromString(collectionName), java:fromString(jsonStringFilter),
                                                                       isMultiple);
    }

    public function stop() {
        closeConnection(self.datasource);
    }
};

function initClient(ClientEndpointConfig config) returns handle = @java:Method {
    class: "org.wso2.mongo.endpoint.InitMongoDbClient"
} external;

function insertData(handle datasource, handle collectionName, handle queryString) = @java:Method {
    class: "org.wso2.mongo.actions.Insert"
} external;

function queryData(handle datasource, handle collectionName, handle? queryString) returns json[] = @java:Method {
    class: "org.wso2.mongo.actions.Find"
} external;

function queryOne(handle datasource, handle collectionName, handle? queryString) returns json = @java:Method {
    class: "org.wso2.mongo.actions.FindOne"
} external;

function replaceData(handle datasource, handle collectionName, handle? filter, handle? document, boolean upsert)
                                                                                          returns int = @java:Method {
    class: "org.wso2.mongo.actions.ReplaceOne"
} external;

function deleteData(handle datasource, handle collectionName, handle? filter, boolean isMultiple)
                                                                                            returns int = @java:Method {
    class: "org.wso2.mongo.actions.Delete"
} external;

function closeConnection(handle datasource)  = @java:Method {
    class: "org.wso2.mongo.actions.Close"
} external;

# The Client endpoint configuration for MongoDB.
#
# + host - The host of the database to connect
# + dbName - The name of the database to connect
# + username - Username for the database connection
# + password - Password for the database connection
# + options - Properties for the connection configuration
public type ClientEndpointConfig record {|
    string host = "";
    string dbName;
    string username = "";
    string password = "";
    ConnectionProperties options = {};
|};

public type ConnectionProperties record {|
    string url = "";
    string readConcern = "";
    string writeConcern = "";
    string readPreference = "";
    string authSource = "";
    string authMechanism = "";
    string gssapiServiceName = "";
    string replicaSet = "";
    boolean sslEnabled = false;
    boolean sslInvalidHostNameAllowed = false;
    boolean retryWrites = false;
    int socketTimeout = -1;
    int connectionTimeout = -1;
    int maxPoolSize = -1;
    int serverSelectionTimeout = -1;
    int maxIdleTime = -1;
    int maxLifeTime = -1;
    int minPoolSize = -1;
    int waitQueueMultiple = -1;
    int waitQueueTimeout = -1;
    int localThreshold = -1;
    int heartbeatFrequency = -1;
|};

public type DatabaseErrorData record {|
    string message;
|};
