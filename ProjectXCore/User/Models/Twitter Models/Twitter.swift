//
//  Twitter.swift
//  ProjectXCore
//
//  Created by Bruce Colby on 7/18/18.
//  Copyright © 2018 AmTrust. All rights reserved.
//

import Foundation

public class Twitter {
    public let followers:   TwitterTally
    public let posts:       TwitterTally
    public let following:   TwitterTally
    public var isFollowing: Bool {
        didSet {
            if ignore { return }
            
            if isFollowing{
                followers.count = followers.count + 1
            } else {
                followers.count = followers.count - 1
            }
        }
    }
    private var ignore = true
    
    public init(followers: TwitterTally, posts: TwitterTally, following: TwitterTally, isFollowing: Bool = false) {
        self.followers = followers
        self.posts     = posts
        self.following = following
        self.isFollowing = isFollowing
        self.ignore = false
    }
}
