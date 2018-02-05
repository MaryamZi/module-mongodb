package ballerina.data.mongodb;

public struct ConnectionProperties {
    string url;
    string username;
    string password;
    string readConcern;
    string writeConcern;
    string readPreference;
    string authSource;
    string authMechanism;
    string gssapiServiceName;
    boolean sslEnabled;
    boolean sslInvalidHostNameAllowed;
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
}

@Description { value:"MongoDB client connector."}
@Param { value:"host:Host addresses of MongoDB" }
@Param { value:"dbName:The name of the database" }
@Param { value:"options: Optional properties for MongoDB connection" }
public connector ClientConnector (string host, string dbName, ConnectionProperties options) {

    map sharedMap = {};

    @Description {value:"The find action implementation which selects a document in a given collection."}
    @Param {value:"collectionName: The name of the collection to be queried"}
    @Param {value:"query: Query to use to select data"}
    @Return {value:"Result returned from the findOne action" }
    native action find (string collectionName, json query) (json);

    @Description {value:"The findOne action implementation which selects the first document match with the query."}
    @Param {value:"collectionName: The name of the collection to be queried"}
    @Param {value:"query: Query to use to select data"}
    @Return {value:"Result returned from the findOne action" }
    native action findOne (string collectionName, json query) (json);

    @Description {value:"The insert action implementation which insert document to a collection."}
    @Param {value:"collectionName: The name of the collection"}
    @Param {value:"document: The document to be inserted"}
    native action insert (string collectionName, json document);

    @Description {value:"The delete action implementation which deletes documents that matches the given filter."}
    @Param {value:"collectionName: The name of the collection"}
    @Param {value:"filter: The criteria used to delete the documents"}
    @Param {value:"multi: Specifies whether to delete multiple documents or not"}
    @Return {value:"Updated count during the update action" }
    native action delete (string collectionName, json filter, boolean multi) (int);

    @Description {value:"The update action implementation which update documents that matches to given filter."}
    @Param {value:"collectionName: The name of the collection"}
    @Param {value:"filter: The criteria used to update the documents"}
    @Param {value:"multi: Specifies whether to update multiple documents or not"}
    @Param {value:"upsert: Specifies whether to create a new document when no document matches the filter"}
    @Return {value:"Updated count during the update action" }
    native action update (string collectionName, json filter, json document, boolean multi, boolean upsert) (int);

    @Description {value:"The insert action implementation which inserts an array of documents to a collection."}
    @Param {value:"collectionName: The name of the collection"}
    @Param {value:"documents: The document array to be inserted"}
    native action batchInsert (string collectionName, json documents);

    @Description {value:"The close action implementation which closes the MongoDB connection pool."}
    native action close ();
 }
