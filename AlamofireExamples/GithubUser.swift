//
//  GithubUser.swift
//  AlamofireExamples
//
//  Created by Nicholas Brandt on 4/27/18.
//  Copyright © 2018 Nicholas Brandt. All rights reserved.
//

import Foundation

struct GithubUser : Codable {
    let login : String
    let id: Int
    let avatarUrl: URL
    let url: URL
    let htmlUrl: URL
    let followersUrl: URL
    let followingUrl: String // Has error parsing into URL
    let gistsUrl: String // Has error parsing into URL
    let starredUrl: String // Has error parsing into URL
    let subscriptionsUrl: URL
    let organizationsUrl: URL
    let reposUrl: URL
    let eventsUrl: String // Has error parsing into URL
    let receivedEventsUrl: URL
    let type: String
    let siteAdmin: Bool
    let name: String
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: Bool?
    let bio: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: Date
    let updatedAt: Date
}
