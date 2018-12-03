# DeeplinkingCredentialSwitcher
A class that helps you change credentials at run time based on a deep link

## Usage

This repo has two main components - Deeplinking Manager and DeeplinkingCredentialsManager

Deeplinking Manager :-
    A class intended to be used as is with minimal / no modifications.

DeeplinkingCredentialsManager :-
   A class whose instance communicates with the DeeplinkingManager / parses and stores the key to be returned.You have to 
modify it based on your requirement.

Now that you have a heads up lets get straight to the implementation.

## Implementation

1) Add the above files to your project and in your app delegate add the following to your openURL function :

```
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        DeeplinkingManager.retainedInstance.parseDeeplink(url: url, options: options)
        return true
    }
```
    Once an app is opened via a deep link it is this func that is invoked , we just let our DeeplinkingManger class handle
handle the parsing. 

2) Now in your viewcontroller class if you want the key based on a deep link all you have to do is

```
let key = DeeplinkingManager.retainedInstance.key()
```

and that's it.

## DeeplinkCredentialManager.swift

This class contains the basic parsing logic , here CustomType has two mode's and each mode in turn has live , debug
and partner keys.You can change the structure based on your requirement.

the main func that you should focus on is 

```
    func valueFrom<ReturnType,Type>(keyPath:KeyPath<DeeplinkCredentialManager,Type>,defaultValue:ReturnType) -> ReturnType {
        let value = self[keyPath:keyPath]
        
        let mirror = Mirror(reflecting: value)
        guard mirror.displayStyle == Mirror.DisplayStyle.optional,mirror.children.count == 1,let child = mirror.children.first?.value as? ReturnType else{
            return defaultValue
        }
        return child
    }
```

This func uses a key path to fetch the value of any instance variable irrespetive of the type.It ultimately uses reflection to get
unwrapped value if the value returned is an optional.

You can use it like this 

```
DeeplinkingCredentialsManager().valueFrom(keyPath: \DeeplinkCredentialManager.key, defaultValue: String())
```
