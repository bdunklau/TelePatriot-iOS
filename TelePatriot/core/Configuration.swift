//
//  Configuration.swift
//  TelePatriot
//
//  Created by Brent Dunklau on 12/3/18.
//  Copyright © 2018 Brent Dunklau. All rights reserved.
//

import Foundation

struct Configuration : Decodable {
    
    var cb_production_environment : Environment?
    var cb_qa_environment : Environment?
    var environment = ""
    private var get_missions_from = ""
    private var get_roles_from = ""
    var get_teams_from = ""
    var on_user_created = ""
    var on_user_login = ""
    var simulate_banned = false
    var simulate_missing_email = false
    var simulate_missing_name = false
    var simulate_no_confidentiality_agreement = false
    var simulate_no_petition = false
    var simulate_passing_legal = false
    
    struct Environment : Decodable {
        var citizen_builder_api_key_name = ""
        var citizen_builder_api_key_value = ""
        var citizen_builder_domain = ""
        
        init(data: [String:Any]) {
            if let val = data["citizen_builder_api_key_name"] as? String {
                citizen_builder_api_key_name = val
            }
            if let val = data["citizen_builder_api_key_value"] as? String {
                citizen_builder_api_key_value = val
            }
            if let val = data["citizen_builder_domain"] as? String {
                citizen_builder_domain = val
            }
        }
    }
    
    init(data: [String:Any]) {
        
        if let env = data["cb_production_environment"] as? [String:Any] {
            cb_production_environment = Environment(data: env)
        }
        
        if let env = data["cb_qa_environment"] as? [String:Any] {
            cb_qa_environment = Environment(data: env)
        }
        
        if let val = data["environment"] as? String {
            environment = val
        }
        
        if let val = data["get_missions_from"] as? String {
            get_missions_from = val
        }
        
        if let val = data["get_roles_from"] as? String {
            get_roles_from = val
        }
        
        if let val = data["get_teams_from"] as? String {
            get_teams_from = val
        }
        
        if let val = data["on_user_created"] as? String {
            on_user_created = val
        }
        
        if let val = data["on_user_login"] as? String {
            on_user_login = val
        }
        
        if let val = data["simulate_banned"] as? Bool {
            simulate_banned = val
        }
        
        if let val = data["simulate_missing_email"] as? Bool {
            simulate_missing_email = val
        }
        
        if let val = data["simulate_missing_name"] as? Bool {
            simulate_missing_name = val
        }
        
        if let val = data["simulate_no_confidentiality_agreement"] as? Bool {
            simulate_no_confidentiality_agreement = val
        }
        
        if let val = data["simulate_no_petition"] as? Bool {
            simulate_no_petition = val
        }
        
        if let val = data["simulate_passing_legal"] as? Bool {
            simulate_passing_legal = val
        }
        
        
    }
    
    func getMissionsFromCB() -> Bool {
        return get_missions_from == "citizenbuilder"
    }
    
    func getRolesFromCB() -> Bool {
        return get_roles_from == "citizenbuilder"
    }
    
    private func getEnv() -> Environment? {
        var env = cb_production_environment
        if environment == "cb_qa_environment" {
            env = cb_qa_environment
        }
        return env
    }
    
    func getCitizenBuilderDomain() -> String? {
        return getEnv()?.citizen_builder_domain
    }
    
    func getCitizenBuilderApiKeyName() -> String? {
        return getEnv()?.citizen_builder_api_key_name
    }
    
    func getCitizenBuilderApiKeyValue() -> String? {
        return getEnv()?.citizen_builder_api_key_value
    }
    
}
