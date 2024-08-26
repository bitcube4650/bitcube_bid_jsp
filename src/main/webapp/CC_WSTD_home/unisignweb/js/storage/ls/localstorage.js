var LocalStorage=function(err_code){this.__storageMode=null;this.__storageElement=null;this.__err_code=err_code;if(window.localStorage)try{window.localStorage.setItem("__cc_storage_test__","__cc_storage_test__");window.localStorage.removeItem("__cc_storage_test__");this.__storageMode="localstorage"}catch(e){var err={};err.code=this.__err_code.ERROR_PRIVATE_BROWSING_MODE;err.message="[LocalStorage Initializing Failed] private browsing mode.\n";err.detail=e;throw err;}else{this.__storageElement=document.createElement("link");this.__storageElement.style.display="none";if(this.__storageElement.addBehavior){this.__storageElement.style.behavior="url(#default#userData)";document.body.appendChild(this.__storageElement);try{this.__storageElement.load("localstorage")}catch(e){this.__storageElement.setAttribute("localstorage","{}");this.__storageElement.save("localstorage");this.__storageElement.load("localstorage")}this.__storageMode="userdata"}else{var err={};err.code=this.__err_code.ERROR_UNSUPPORT_FREE_STORAGE;err.message="[LocalStorage Initializing Failed] new storage is unavailable.";err.detail=null;throw err;}}};LocalStorage.prototype={SetItem:function(key,value){if(!key||!value){var err={};err.code=this.__err_code.ERROR_PARAMETER_VALUE_IS_NULL;err.message="[LocalStorage SetItem Failed] the parameter value cannot be null.";err.detail=null;throw err;}try{if("localstorage"===this.__storageMode)window.localStorage.setItem(key,value);else if("userdata"===this.__storageMode){this.__storageElement.setAttribute(key,value);this.__storageElement.save("localstorage")}else{var err={};err.code=this.__err_code.ERROR_STORAGE_WASNT_INITIALIZED;err.message="[LocalStorage SetItem Failed] new storage was not initialized.";err.detail=null;throw err;}}catch(e){var err={};err.code=this.__err_code.ERROR_PRIVATE_BROWSING_MODE;err.message="[LocalStorage SetItem Failed] private browsing mode or the space is full. check detail reason.";err.detail=e;throw err;}return},GetItem:function(key){if(!key){var err={};err.code=this.__err_code.ERROR_PARAMETER_VALUE_IS_NULL;err.message="[LocalStorage GetItem Failed] the parameter value cannot be null.";err.detail=null;throw err;}var result=null;try{if("localstorage"===this.__storageMode)result=window.localStorage.getItem(key);else if("userdata"===this.__storageMode)result=this.__storageElement.getAttribute(key);else{var err={};err.code=this.__err_code.ERROR_STORAGE_WASNT_INITIALIZED;err.message="[LocalStorage GetItem Failed] new storage was not initialized.";err.detail=null;throw err;}}catch(e){var err={};err.code=this.__err_code.ERROR_STORAGE_GET_ITEM;err.message="[LocalStorage GetItem Failed] get item is failed. check detail reason.";err.detail=e;throw err;}return result},RemoveItem:function(key){if(!key){var err={};err.code=this.__err_code.ERROR_PARAMETER_VALUE_IS_NULL;err.message="[LocalStorage RemoveItem Failed] the parameter value cannot be null.";err.detail=null;throw err;}try{if("localstorage"===this.__storageMode)window.localStorage.removeItem(key);else if("userdata"===this.__storageMode){this.__storageElement.removeAttribute(key,value);this.__storageElement.save("localstorage")}else{var err={};err.code=this.__err_code.ERROR_STORAGE_WASNT_INITIALIZED;err.message="[LocalStorage RemoveItem Failed] new storage was not initialized.";err.detail=null;throw err;}}catch(e){var err={};err.code=this.__err_code.ERROR_STORAGE_REMOVE_ITEM;err.message="[LocalStorage RemoveItem Failed] remove item is failed. check detail reason.";err.detail=e;throw err;}return},Clear:function(){try{window.localStorage.clear()}catch(e){var err={};err.code=this.__err_code.ERROR_STORAGE_CLEAR;err.message="[LocalStorage Clear Failed] clear storage is failed. check detail reason.";err.detail=e;throw err;}return}};