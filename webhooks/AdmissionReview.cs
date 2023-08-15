public class Labels
{
    public string app { get; set; }
    public string metrics_scraper { get; set; }
    public string version { get; set; }
}

public class Annotations
{
    public string app { get; set; }
}

public class Metadata
{
    public object creationTimestamp { get; set; }
    public Labels labels { get; set; }
    public Annotations annotations { get; set; }
}

public class PersistentVolumeClaim
{
    public string name { get; set; }
}

public class ConfigMap
{
    public string name { get; set; }
    public int defaultMode { get; set; }
}

public class Volume
{
    public string name { get; set; }
    public PersistentVolumeClaim persistentVolumeClaim { get; set; }
}

public class ValueFrom
{
    public SecretKeyRef secretKeyRef { get; set; }
}

public class Env
{
    public string name { get; set; }
    public ValueFrom valueFrom { get; set; }
}

public class Limits
{
    public string cpu { get; set; }
    public string memory { get; set; }
}

public class Requests
{
    public string cpu { get; set; }
    public string memory { get; set; }
}

public class Resources
{
    public Limits limits { get; set; }
    public Requests requests { get; set; }
}

public class HttpGet
{
    public string path { get; set; }
    public int port { get; set; }
    public string scheme { get; set; }
}

public class LivenessProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class ReadinessProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class StartupProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class Container
{
    public string name { get; set; }
    public string image { get; set; }
    public List<Env> env { get; set; }
    public Resources resources { get; set; }
    public List<Volume> volumeMounts { get; set; }
    public LivenessProbe livenessProbe { get; set; }
    public ReadinessProbe readinessProbe { get; set; }
    public StartupProbe startupProbe { get; set; }
    public string terminationMessagePath { get; set; }
    public string terminationMessagePolicy { get; set; }
    public string imagePullPolicy { get; set; }
}

public class Spec
{
    public int replicas { get; set; }
    public Selector selector { get; set; }
    public List<Volume> volumes { get; set; }
    public List<Container> containers { get; set; }
    public string restartPolicy { get; set; }
    public int terminationGracePeriodSeconds { get; set; }
    public string dnsPolicy { get; set; }
    public object securityContext { get; set; } // This should be a Dictionary or a class defining securityContext properties
    public string schedulerName { get; set; }
}

public class Template
{
    public Metadata metadata { get; set; }
    public Spec spec { get; set; }
}

public class Metadata
{
    public string name { get; set; }
    public string @namespace { get; set; }
    public string uid { get; set; }
    public int generation { get; set; }
    public DateTime creationTimestamp { get; set; }
    public Dictionary<string, string> labels { get; set; }
    public Dictionary<string, string> annotations { get; set; }
}

public class Selector
{
    public Dictionary<string, string> matchLabels { get; set; }
}

public class PersistentVolumeClaim
{
    public string claimName { get; set; }
}

public class ConfigMap
{
    public string name { get; set; }
    public int defaultMode { get; set; }
}

public class SecretKeyRef
{
    public string name { get; set; }
    public string key { get; set; }
}

public class ValueFrom
{
    public SecretKeyRef secretKeyRef { get; set; }
}

public class Env
{
    public string name { get; set; }
    public ValueFrom valueFrom { get; set; }
}

public class Limits
{
    public string cpu { get; set; }
    public string memory { get; set; }
}

public class Requests
{
    public string cpu { get; set; }
    public string memory { get; set; }
}

public class Resources
{
    public Limits limits { get; set; }
    public Requests requests { get; set; }
}

public class HttpGet
{
    public string path { get; set; }
    public int port { get; set; }
    public string scheme { get; set; }
}

public class LivenessProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class ReadinessProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class StartupProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class Container
{
    public string name { get; set; }
    public string image { get; set; }
    public List<Env> env { get; set; }
    public Resources resources { get; set; }
    public List<object> volumeMounts { get; set; }
    public LivenessProbe livenessProbe { get; set; }
    public ReadinessProbe readinessProbe { get; set; }
    public StartupProbe startupProbe { get; set; }
    public string terminationMessagePath { get; set; }
    public string terminationMessagePolicy { get; set; }
    public string imagePullPolicy { get; set; }
}

public class Spec
{
    public int replicas { get; set; }
    public Selector selector { get; set; }
    public Dictionary<string, object> template { get; set; } // This should be a Dictionary since it contains a nested object
    public string restartPolicy { get; set; }
    public int terminationGracePeriodSeconds { get; set; }
    public string dnsPolicy { get; set; }
    public object securityContext { get; set; } // This should be a Dictionary or a class defining securityContext properties
    public string schedulerName { get; set; }
}

public class RollingUpdate
{
    public string maxUnavailable { get; set; }
    public string maxSurge { get; set; }
}

public class Strategy
{
    public string type { get; set; }
    public RollingUpdate rollingUpdate { get; set; }
}

public class Object
{
    public string kind { get; set; }
    public string apiVersion { get; set; }
    public Metadata metadata { get; set; }
    public Spec spec { get; set; }
    public Strategy strategy { get; set; }
    public int revisionHistoryLimit { get; set; }
    public int progressDeadlineSeconds { get; set; }
}

public class UserInfo
{
    public string username { get; set; }
    public List<string> groups { get; set; }
}

public class Options
{
    public string kind { get; set; }
    public string apiVersion { get; set; }
    public string fieldManager { get; set; }
    public string fieldValidation { get; set; }
}

public class Request
{
    public string uid { get; set; }
    public Dictionary<string, string> kind { get; set; }
    public Dictionary<string, string> resource { get; set; }
    public Dictionary<string, string> requestKind { get; set; }
    public Dictionary<string, string> requestResource { get; set; }
    public string name { get; set; }
    public string @namespace { get; set; }
    public string operation { get; set; }
    public UserInfo userInfo { get; set; }
    public Object @object { get; set; }
    public object oldObject { get; set; }
    public bool dryRun { get; set; }
    public Options options { get; set; }
}

public class AdmissionReview
{
    public string kind { get; set; }
    public string apiVersion { get; set; }
    public Request request { get; set; }
}
Please note that the "template" property is now defined as Dictionary<string, object> because it contains a nested object with its own set of properties. Similarly, the "securityContext" property is defined as object because it is not fully represented in the JSON data provided. Depending on the structure of the "securityContext" object, you might need to define a separate class for it with its properties.




User
convert this to class c#  : "template": {
          "metadata": {
            "creationTimestamp": null,
            "labels": {
              "app": "uploader-api",
              "metrics-scraper": "prom",
              "version": "v1"
            },
            "annotations": {
              "app": "uploader-api"
            }
          },
          "spec": {
            "volumes": [
              {
                "name": "imagestore",
                "persistentVolumeClaim": {
                  "claimName": "imagestoreclaim"
                }
              },
              {
                "name": "appsettings-volume",
                "configMap": {
                  "name": "appsettings",
                  "defaultMode": 420
                }
              }
            ],
            "containers": [
              {
                "name": "uploader-api",
                "image": "rohitrustagi007/evo_uploader:0.1.0",
                "ports": [
                  {
                    "name": "uploader-api",
                    "containerPort": 80,
                    "protocol": "TCP"
                  }
                ],
                "env": [
                  {
                    "name": "ASPNETCORE_ENVIRONMENT",
                    "value": "Production"
                  },
                  {
                    "name": "AWS_ACCESS_KEY",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "access",
                        "key": "AWS_ACCESS_KEY"
                      }
                    }
                  },
                  {
                    "name": "AWS_SECRET_KEY",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "secret",
                        "key": "AWS_SECRET_KEY"
                      }
                    }
                  }
                ],
                "resources": {
                  "limits": {
                    "cpu": "200m",
                    "memory": "256Mi"
                  },
                  "requests": {
                    "cpu": "100m",
                    "memory": "128Mi"
                  }
                },
                "volumeMounts": [
                  {
                    "name": "imagestore",
                    "mountPath": "/images"
                  },
                  {
                    "name": "appsettings-volume",
                    "mountPath": "/app/Settings"
                  }
                ],
                "livenessProbe": {
                  "httpGet": {
                    "path": "/healthz",
                    "port": 80,
                    "scheme": "HTTP"
                  },
                  "timeoutSeconds": 1,
                  "periodSeconds": 10,
                  "successThreshold": 1,
                  "failureThreshold": 3
                },
                "readinessProbe": {
                  "httpGet": {
                    "path": "/healthz",
                    "port": 80,
                    "scheme": "HTTP"
                  },
                  "timeoutSeconds": 1,
                  "periodSeconds": 10,
                  "successThreshold": 3,
                  "failureThreshold": 3
                },
                "startupProbe": {
                  "httpGet": {
                    "path": "/health",
                    "port": 80,
                    "scheme": "HTTP"
                  },
                  "timeoutSeconds": 1,
                  "periodSeconds": 10,
                  "successThreshold": 1,
                  "failureThreshold": 30
                },
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "imagePullPolicy": "Always"
              }
            ],
            "restartPolicy": "Always",
            "terminationGracePeriodSeconds": 30,
            "dnsPolicy": "ClusterFirst",
            "securityContext": {
              
            },
            "schedulerName": "default-scheduler"
          }
        }
ChatGPT
Sure, here's the C# class representation for the "template" object:

csharp
Copy code
using System.Collections.Generic;

public class Labels
{
    public string app { get; set; }
    public string metrics_scraper { get; set; }
    public string version { get; set; }
}

public class Annotations
{
    public string app { get; set; }
}

public class Metadata
{
    public object creationTimestamp { get; set; }
    public Labels labels { get; set; }
    public Annotations annotations { get; set; }
}

public class PersistentVolumeClaim
{
    public string name { get; set; }
}

public class ConfigMap
{
    public string name { get; set; }
    public int defaultMode { get; set; }
}

public class Volume
{
    public string name { get; set; }
    public PersistentVolumeClaim persistentVolumeClaim { get; set; }
}

public class ValueFrom
{
    public SecretKeyRef secretKeyRef { get; set; }
}

public class Env
{
    public string name { get; set; }
    public ValueFrom valueFrom { get; set; }
}

public class Limits
{
    public string cpu { get; set; }
    public string memory { get; set; }
}

public class Requests
{
    public string cpu { get; set; }
    public string memory { get; set; }
}

public class Resources
{
    public Limits limits { get; set; }
    public Requests requests { get; set; }
}

public class HttpGet
{
    public string path { get; set; }
    public int port { get; set; }
    public string scheme { get; set; }
}

public class LivenessProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class ReadinessProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class StartupProbe
{
    public HttpGet httpGet { get; set; }
    public int timeoutSeconds { get; set; }
    public int periodSeconds { get; set; }
    public int successThreshold { get; set; }
    public int failureThreshold { get; set; }
}

public class Container
{
    public string name { get; set; }
    public string image { get; set; }
    public List<Env> env { get; set; }
    public Resources resources { get; set; }
    public List<Volume> volumeMounts { get; set; }
    public LivenessProbe livenessProbe { get; set; }
    public ReadinessProbe readinessProbe { get; set; }
    public StartupProbe startupProbe { get; set; }
    public string terminationMessagePath { get; set; }
    public string terminationMessagePolicy { get; set; }
    public string imagePullPolicy { get; set; }
}

public class Spec
{
    public int replicas { get; set; }
    public Selector selector { get; set; }
    public List<Volume> volumes { get; set; }
    public List<Container> containers { get; set; }
    public string restartPolicy { get; set; }
    public int terminationGracePeriodSeconds { get; set; }
    public string dnsPolicy { get; set; }
    public object securityContext { get; set; } // This should be a Dictionary or a class defining securityContext properties
    public string schedulerName { get; set; }
}

public class Template
{
    public Metadata metadata { get; set; }
    public Spec spec { get; set; }
}
Please note that the "securityContext" property is defined as object because it is not fully represented in the JSON data provided. Depending on the structure of the "securityContext" object, you might need to define a separate class for it with its properties.





