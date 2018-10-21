const authorSchema = new moongoose.Schema({
    name: String,
    website: String
});

const Author = moongoose.model('Author', authorSchema);

const courseSchema = new moongoose.Schema({
    name: {
        type: String,
        required: true,
        minlength: 5,
        maxlength: 255,
        //match per regex
    },
    author: {
        type: moongoose.Schema.Types.ObjectId,
        ref: 'Author'
    },
    //OSE PER TE VENDOSUR DOCUMENT BRENDA KUR ESHTE NOT NORMALIZED 
    //author:authorSchema
    category: {
        type: String,
        required: true,
        enum: [
            'web',
            'mobile',
            'network'
        ],
        lowercase: true,
        trim: true,
        //uppercase:true
    },
    tags: {
        type: Array,
        validate: {
            isAsync: true,
            validator: function (v, callback) {
                setTimeout(() => {
                    const result = v && v.length > 0;
                    callback(result);
                }, 3000);
            },
            message: 'A course should have at least one tag.'
        }
    },
    date: {
        type: Date,
        default: Date.now
    },
    isPublished: Boolean,
    price: {
        type: Number,
        required: function () {
            return this.isPublished;
        },
        min: 10,
        max: 200,
        get: v => Math.round(v),
        set: v => Math.round(v)
    }
});

const Course = moongoose.model('Course', courseSchema);

async function createCourse() {

    const course = new Course({
        name: 'React ',
        author: 'Neri',
        tags: ['react', 'frontend'],
        isPublished: false
    });

    try {
        const result = await course.save();
        console.log(result);

    } catch (ex) {
        for (f in ex.errors) {
            console.log(ex.errprs[field].message);
        }

    }

}
async function getCouses() {

    const result = await Course
        //.find({author:'Neri',isPublished:false})

        //.find({price:{$gte:10,$lte:20}})

        //.find({ price: { $in:[10,15,20] }})

        // .find()
        // .or([{author:'Neri'},{isPublished:true}])

        .find({
            author: /.*Neri.*/i
        })
        .limit(10)
        .sort({
            name: 1
        })
        .select({
            name: 1,
            tags: 1
        });
    //.count();

    console.log(result);
}
getCouses();
